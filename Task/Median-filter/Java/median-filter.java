import java.awt.Color;
import java.awt.Graphics;
import java.awt.Image;
import java.awt.image.BufferedImage;
import java.awt.image.RenderedImage;
import java.io.File;
import java.io.IOException;
import java.util.Collections;
import java.util.Comparator;
import java.util.List;
import java.util.stream.Collectors;
import java.util.stream.Stream;

import javax.imageio.ImageIO;

public final class MedianFilter {

	public static void main(String[] aArgs) {
		try {
			BufferedImage image = ImageIO.read( new File("beforeFilter.png") );
			BasicBitmapStorage bitmap = new BasicBitmapStorage(image.getWidth(null), image.getHeight(null));
		
	        for ( int y = 0; y < image.getHeight(null); y++ ) {
	            for ( int x = 0; x < image.getWidth(null); x++ ) {
	                bitmap.setPixel(x, y, new Color(image.getRGB(x, y), true));
	            }
	        }
	
	        bitmap.medianFilter(3, 3);
	        File fileAfterFilter = new File("afterFilter.png");
	        ImageIO.write((RenderedImage) bitmap.getImage(), "png", fileAfterFilter);
		} catch (IOException ioe) {
			ioe.printStackTrace();
		}
	}	
	
}

final class BasicBitmapStorage {

	public BasicBitmapStorage(int aWidth, int aHeight) {
        image = new BufferedImage(aWidth, aHeight, BufferedImage.TYPE_INT_RGB);
    }

    public void fill(Color aColor) {
        Graphics graphics = image.getGraphics();
        graphics.setColor(aColor);
        graphics.fillRect(0, 0, image.getWidth(), image.getHeight());
    }

    public Color getPixel(int aX, int aY) {
        return new Color(image.getRGB(aX, aY));
    }

    public void setPixel(int aX, int aY, Color aColor) {
        image.setRGB(aX, aY, aColor.getRGB());
    }

    public Image getImage() {
    	return image;
    }

    public void medianFilter(int aWindowWidth, int aWindowHeight) {
    	List<Color> window = Stream.generate( () -> Color.BLACK )
    		.limit(aWindowWidth * aWindowHeight).collect(Collectors.toList());	
        final int edgeX = aWindowWidth / 2;
        final int edgeY = aWindowHeight / 2;
        Comparator<Color> luminanceComparator = (one, two) -> Double.compare(luminance(one), luminance(two));

        for ( int x = edgeX; x < image.getWidth() - edgeX; x++ ) {
            for ( int y = edgeY; y < image.getHeight() - edgeY; y++ ) {
                int i = 0;
                for ( int fx = 0; fx < aWindowWidth; fx++ ) {
                    for ( int fy = 0; fy < aWindowHeight; fy++ ) {
                        window.set(i, getPixel(x + fx - edgeX, y + fy - edgeY));
                        i += 1;
                    }
                }

                Collections.sort(window, luminanceComparator);
                setPixel(x, y, window.get(aWindowWidth * aWindowHeight / 2));
            }
        }
    }

    private double luminance(Color aColor) {
    	return 0.2126 * aColor.getRed() + 0.7152 * aColor.getGreen() + 0.0722 * aColor.getBlue();
    }

    private final BufferedImage image;

}
