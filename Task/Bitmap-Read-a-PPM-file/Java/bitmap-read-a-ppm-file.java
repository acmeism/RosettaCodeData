import java.awt.Color;
import java.awt.Graphics;
import java.awt.Image;
import java.awt.image.BufferedImage;
import java.awt.image.RenderedImage;
import java.io.BufferedInputStream;
import java.io.File;
import java.io.FileInputStream;
import java.io.IOException;

import javax.imageio.ImageIO;

public class ReadPPMFile {

	public static void main(String[] aArgs) throws IOException {
        // Using the file created in the Bitmap task
		String filePath = "output.ppm";
		
		reader = new BufferedInputStream( new FileInputStream(filePath) );
		final char header1 = (char) reader.read();
        final char header2 = (char) reader.read();
        final char header3 = (char) reader.read();
        if ( header1 != 'P' || header2 != '6' || header3 != END_OF_LINE) {
        	reader.close();
        	throw new IllegalArgumentException("Not a valid P6 PPM file");
        }

        final int width = processCharacters(SPACE_CHARACTER);
        final int height = processCharacters(END_OF_LINE);
        final int maxColorValue = processCharacters(END_OF_LINE);
        if ( maxColorValue < 0 || maxColorValue > 255 ) {
        	reader.close();
        	throw new IllegalArgumentException("Maximum color value is outside the range 0..255");
        }

        // Remove any comments before reading data
        reader.mark(1);
        while ( reader.read() == START_OF_COMMENT ) {
        	 while ( reader.read() != END_OF_LINE );
        	 reader.mark(1);
        }
        reader.reset();

       // Read data
        BasicBitmapStorage bitmap = new BasicBitmapStorage(width, height);

        byte[] buffer = new byte[width * 3];
        for ( int y = 0; y < height; y++ ) {
            reader.read(buffer, 0, buffer.length);
            for ( int x = 0; x < width; x++ ) {                	
                Color color = new Color(Byte.toUnsignedInt(buffer[x * 3]),
                						Byte.toUnsignedInt(buffer[x * 3 + 1]),
                						Byte.toUnsignedInt(buffer[x * 3 + 2]));
                bitmap.setPixel(x, y, color);
            }
        }

        reader.close();

        // Convert to gray scale and save to a file
        bitmap.convertToGrayscale();
        File grayFile = new File("outputGray.jpg");
        ImageIO.write((RenderedImage) bitmap.getImage(), "jpg", grayFile);  	
	}
	
	private static int processCharacters(char aChar) throws IOException {
		StringBuilder characters = new StringBuilder();
		char ch;		
		while ( ( ch = (char) reader.read() ) != aChar ) {
        	if ( ch == START_OF_COMMENT ) {
        		while ( reader.read() != END_OF_LINE );
        		continue;
        	}
        	characters.append(ch);
        }
		return Integer.valueOf(characters.toString());
	}
	
	private static BufferedInputStream reader;
	
	private static final char START_OF_COMMENT = '#';
	private static final char SPACE_CHARACTER = ' ';
	private static final char END_OF_LINE = '\n';

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

    public void convertToGrayscale() {
        for ( int y = 0; y < image.getHeight(); y++ ) {
           	for ( int x = 0; x < image.getWidth(); x++ ) {
                int color = image.getRGB(x, y);

                int alpha = ( color >> 24 ) & 255;
                int red = ( color >> 16 ) & 255;
                int green = ( color >> 8 ) & 255;
                int blue = color & 255;

                final int luminance = (int) ( 0.2126 * red + 0.7152 * green + 0.0722 * blue );

                alpha = alpha << 24;
                red = luminance << 16;
                green = luminance << 8;
                blue = luminance;

                color = alpha + red + green + blue;

                image.setRGB(x, y, color);
            }
        }
    }

    private final BufferedImage image;

}
