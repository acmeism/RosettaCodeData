import java.awt.Color;
import java.awt.image.BufferedImage;
import java.io.File;
import java.io.IOException;
import java.util.List;
import java.util.stream.IntStream;

import javax.imageio.ImageIO;

public final class FloydSteinbergDithering {

	public static void main() throws IOException {
		BufferedImage original = ImageIO.read( new File("./Lenna.png") );
        BufferedImage dithered = FloydSteinberg.dither(original);
        ImageIO.write(dithered, "png", new File("./Dithered.png"));
	}

}

final class FloydSteinberg {
	
	public static BufferedImage dither(BufferedImage image) {
		final int width = image.getWidth();
		final int height = image.getHeight();
		
		Hue[][] imageCopy = IntStream.range(0, height).mapToObj( i -> IntStream.range(0, width)
			.mapToObj( j -> new Hue(image.getRGB(j, i)) ).toArray(Hue[]::new) ).toArray(Hue[][]::new);
		
		for ( int y = 0; y < height; y++ ) {
	        for ( int x = 0; x < width; x++ ) {
	        	Hue oldHue = imageCopy[y][x];
	            Hue newHue = oldHue.closestHue(PALETTE);
	            image.setRGB(x, y, newHue.toColor().getRGB());
	
	            Hue error = oldHue.subtract(newHue);

                if ( x + 1 < width ) {
                    imageCopy[y][x + 1] = imageCopy[y][x + 1].add(error.scalarMultiply(7.0 / 16.0));
                }

                if ( y + 1 < height ) {
                	if ( ( x - 1 ) >= 0 ) {
                		imageCopy[y + 1][x - 1] = imageCopy[y + 1][x - 1].add(error.scalarMultiply(3.0 / 16.0));
                	}

                    imageCopy[y + 1][x] = imageCopy[y + 1][x].add(error.scalarMultiply(5.0 / 16.0));

                    if ( x + 1 < width ) {
                    	imageCopy[y + 1][x + 1] = imageCopy[y + 1][x + 1].add(error.scalarMultiply(1.0 / 16.0));
                    }
                }
	        }	
	    }
		
		return image;
	}
	
	private static final List<Hue> PALETTE = List.of(
	    new Hue(  0,   0,   0), // Black
	    new Hue(  0,   0, 255), // Green
	    new Hue(  0, 255,   0), // Blue
	    new Hue(  0, 255, 255), // Cyan
	    new Hue(255,   0,   0), // Red
	    new Hue(255,   0, 255), // Purple
	    new Hue(255, 255,   0), // Yellow
	    new Hue(255, 255, 255)  // White
	);		

}

final record Hue(int red, int green, int blue) {

    public Hue(int valueRGB) {
        Color color = new Color(valueRGB);
        this(color.getRed(), color.getGreen(), color.getBlue());
    }

    public Hue add(Hue other) {
        return new Hue(red + other.red, green + other.green, blue + other.blue);
    }

    public Hue subtract(Hue other) {
        return new Hue(red - other.red, green - other.green, blue - other.blue);
    }

    public Hue scalarMultiply(double factor) {
        return new Hue((int) ( factor * red ), (int) ( factor * green ), (int) ( factor * blue ));
    }

    public Color toColor() {
        return new Color(clamp(red), clamp(green), clamp(blue));
    }

    public Hue closestHue(List<Hue> palette) {	    	
    	return palette.stream().reduce( (a, b) -> ( hueDistance(a) < hueDistance(b) ) ? a : b ).get();
    }

    private int hueDistance(Hue other) {
        final int distanceR = red - other.red;
        final int distanceG = green - other.green;
        final int distanceB = blue - other.blue;
        return distanceR * distanceR + distanceG * distanceG + distanceB * distanceB;
    }

    private int clamp(int value) {
        return Math.max(0, Math.min(255, value));
    }

}
