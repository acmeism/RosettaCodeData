import java.awt.Color;
import java.awt.image.BufferedImage;
import java.io.File;
import java.io.IOException;
import java.util.ArrayList;
import java.util.Collections;
import java.util.Comparator;
import java.util.List;

import javax.imageio.ImageIO;

public final class ColorQuantization {

	public static void main(String[] aArgs) throws IOException {
		BufferedImage original = ImageIO.read( new File("quantum_frog.png") );
		final int width = original.getWidth();
		final int height = original.getHeight();
		int[] originalPixels = original.getRGB(0, 0, width, height, null, 0, width);
		
		List<Item> bucket = new ArrayList<Item>();
		for ( int i = 0; i < originalPixels.length; i++ ) {
			bucket.add( new Item(new Color(originalPixels[i]), i) );
		}
		
		int[] resultPixels = new int[originalPixels.length];		
		medianCut(bucket, 4, resultPixels);		
		
		BufferedImage result = new BufferedImage(width, height, original.getType());
		result.setRGB(0, 0, width, height, resultPixels, 0, width);
		ImageIO.write(result, "png", new File("Quantum_frog16Java.png"));
		
		System.out.println("The 16 colors used in Red, Green, Blue format are:");
		for ( Color color : colorsUsed ) {
			System.out.println("(" + color.getRed() + ", " + color.getGreen() + ", " + color.getBlue() + ")");
		}
	}
	
	private static void medianCut(List<Item> aBucket, int aDepth, int[] aResultPixels) {
		if ( aDepth == 0 ) {
		    quantize(aBucket, aResultPixels);
		    return;
		}
		
		int[] minimumValue = new int[] { 256, 256, 256 };
		int[] maximumValue = new int[] { 0, 0, 0 };
		for ( Item item : aBucket ) {
		    for ( Channel channel : Channel.values() ) {
		    	int value = item.getPrimary(channel);
		    	if ( value < minimumValue[channel.index] ) {
		    		minimumValue[channel.index] = value;
		    	}
		    	if ( value > maximumValue[channel.index] ) {
		    		maximumValue[channel.index] = value;
		    	}
		    }
		}
		
		int[] valueRange = new int[] { maximumValue[Channel.RED.index] - minimumValue[Channel.RED.index],
		                               maximumValue[Channel.GREEN.index] - minimumValue[Channel.GREEN.index],
		                               maximumValue[Channel.BLUE.index] - minimumValue[Channel.BLUE.index] };
		
		Channel selectedChannel = ( valueRange[Channel.RED.index] >= valueRange[Channel.GREEN.index] )
			? ( valueRange[Channel.RED.index] >= valueRange[Channel.BLUE.index] ) ? Channel.RED : Channel.BLUE
			: ( valueRange[Channel.GREEN.index] >= valueRange[Channel.BLUE.index] ) ? Channel.GREEN : Channel.BLUE;
		
		Collections.sort(aBucket, switch(selectedChannel) {
								  	  case RED -> redComparator;
								  	  case GREEN -> greenComparator;
								  	  case BLUE -> blueComparator; });		
	
		final int medianIndex = aBucket.size() / 2;
		medianCut(new ArrayList<Item>(aBucket.subList(0, medianIndex)), aDepth - 1, aResultPixels);
		medianCut(new ArrayList<Item>(aBucket.subList(medianIndex, aBucket.size())), aDepth - 1, aResultPixels);
	}
	
	private static void quantize(List<Item> aBucket, int[] aResultPixels) {		
		int[] means = new int[Channel.values().length];
        for ( Item item : aBucket ) {
        	for ( Channel channel : Channel.values() ) {
        		means[channel.index] += item.getPrimary(channel);
        	}
        }

        for ( Channel channel : Channel.values() ) {
            means[channel.index] /= aBucket.size();
        }

        Color color = new Color(means[Channel.RED.index], means[Channel.GREEN.index], means[Channel.BLUE.index]);
        colorsUsed.add(color);

        for ( Item item : aBucket ) {
        	aResultPixels[item.aIndex] = color.getRGB();		
        }
	}
	
	private enum Channel {
		RED(0), GREEN(1), BLUE(2);
		
		private Channel(int aIndex) {
			index = aIndex;
		}
		
		private final int index;
	}
	
	private record Item(Color aColor, Integer aIndex) {
		
		public int getPrimary(Channel aChannel) {
			return switch(aChannel) {
				case RED -> aColor.getRed();
				case GREEN -> aColor.getGreen();
				case BLUE -> aColor.getBlue();
			};			
		}
		
	}	
	
	private static Comparator<Item> redComparator =
		(one, two) -> Integer.compare(one.aColor.getRed(), two.aColor.getRed());
	private static Comparator<Item> greenComparator =
		(one, two) -> Integer.compare(one.aColor.getGreen(), two.aColor.getGreen());
	private static Comparator<Item> blueComparator =
		(one, two) -> Integer.compare(one.aColor.getBlue(), two.aColor.getBlue());
		
	private static List<Color> colorsUsed = new ArrayList<Color>();
	
}
