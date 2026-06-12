import java.awt.image.BufferedImage;
import java.io.File;
import java.io.IOException;

import javax.imageio.ImageIO;

public final class ColourSeparation {

	public static void main(String[] args) throws IOException {
		BufferedImage originalImage = ImageIO.read( new File("./Lenna.png") );		
		convertToColorScheme(originalImage, ColorScheme.RGB);
	}
	
	private static void convertToColorScheme(BufferedImage originalImage, ColorScheme colorScheme) throws IOException {
        final int width = originalImage.getWidth();
        final int height = originalImage.getHeight();
        final int[] originalPixels = originalImage.getRGB(0, 0, width, height, null, 0, width);

        int[][] pixels = new int[colorScheme.name().length()][originalPixels.length];

        for ( int i = 0; i < originalPixels.length; i++ ) {
        	final int alpha = ( originalPixels[i] >> 24 ) & 255;
        	final int red = ( originalPixels[i] >> 16 ) & 255;
        	final int green = ( originalPixels[i] >> 8 ) & 255;
        	final int blue = originalPixels[i] & 255;
        	
        	switch ( colorScheme ) {
        		case RGB -> {
        			pixels[0][i] = alpha << 24 | red << 16 | 0 | 0;
        			pixels[1][i] = alpha << 24 | 0 | green << 8 | 0;
        			pixels[2][i] = alpha << 24 | 0 | 0 | blue;
        		}
        		case CMY -> {
        			pixels[0][i] = alpha << 24 | red << 16 | 255 << 8 | 255;
        			pixels[1][i] = alpha << 24 | 255 << 16 | green << 8 | 255;
        			pixels[2][i] = alpha << 24 | 255 << 16 | 255 << 8 | blue;
        		}
        		case CMYK -> {
        			int[] colors = cmykColors(alpha, red, green, blue);
        			for ( int j = 0; j < 4; j++ ) {
        				pixels[j][i] = colors[j];
        			}
        		}
        	}
        }

        for ( int i = 0; i < colorScheme.name().length(); i++ ) {
        	BufferedImage newImage = new BufferedImage(width, height, originalImage.getType());
        	newImage.setRGB(0, 0, width, height, pixels[i], 0, width);
        	String fileName = "Lenna" + String.valueOf(i) + ".png";
        	ImageIO.write(newImage, "png", new File("./Lenna" + i + ".png"));
        }
 	}
	
	private static int[] cmykColors(int alpha, int red, int green, int blue) {
		final int rc = 255 - red;
        final int gc = 255 - green;
        final int bc = 255 - blue;
        final int k = Math.min(Math.min(rc, gc), bc);
        final int kc = 255 - k;

        final int colorK = alpha << 24 | kc << 16 | kc << 8 | kc;
        if ( kc == 0 ) {
        	return new int[] { 0, 0, 0, colorK };
        }

        final int c = ( ( rc - k ) * 255 ) / kc;
        final int m = ( ( gc - k ) * 255 ) / kc;
        final int y = ( ( bc - k ) * 255 ) / kc;
        final int colorC = alpha << 24 | ( 255 - c ) << 16 | 255 << 8 | 255;
        final int colorM = alpha << 24 | 255 << 16 | ( 255 - m ) << 8 | 255;
        final int colorY = alpha << 24 | 255 << 16 | 255 << 8 | 255 - y;	

		return new int[] { colorC, colorM, colorY, colorK };		
	}
	
	private enum ColorScheme { RGB, CMY, CMYK }

}
