import java.awt.Color;
import java.awt.Graphics;
import java.awt.image.BufferedImage;
import java.io.File;
import java.io.IOException;
import java.util.List;

import javax.imageio.ImageIO;

public final class DeathStar {

	public static void main(String[] aArgs) throws IOException {
		Vector direction = new Vector(20.0, -40.0, -10.0);
		direction.normalise();
		Sphere positive = new Sphere(0, 0, 0, 120);
		Sphere negative = new Sphere(-90, -90, -30, 100);

		BufferedImage image = deathStar(positive, negative, direction, 1.5, 0.5);
		
		ImageIO.write(image, "png", new File("DeathStarJava.png"));
	}
	
	private static BufferedImage deathStar(
			Sphere aPositive, Sphere aNegative, Vector aDirection, double aShadow, double aBrightness) {
		final int width = aPositive.radius * 4;
		final int height = aPositive.radius * 3;
		BufferedImage result = new BufferedImage(width, height, BufferedImage.TYPE_INT_RGB);
		Graphics graphics = result.getGraphics();
        graphics.setColor(Color.CYAN);
        graphics.fillRect(0, 0, width, height);

		Vector ray = new Vector(0.0, 0.0, 0.0);
		final int deltaX = aPositive.x - width / 2;
		final int deltaY = aPositive.y - height / 2;

		double xMax = aPositive.x + aPositive.radius;
		double yMax = aPositive.y + aPositive.radius;
		for ( int y = aPositive.y - aPositive.radius; y < yMax; y++ ) {
		    for ( int x = aPositive.x - aPositive.radius; x < xMax; x++ ) {
		    	List<Object> contacts = aPositive.contact(x, y);
		    	final double zb1 = (double) contacts.get(0);
		    	final int zb2 = (int) contacts.get(1);
		    	final boolean positiveHit = (boolean) contacts.get(2);
		    	if ( ! positiveHit ) {
		    		continue;
		    	}
	       		contacts = aNegative.contact(x, y);
	       		final double zs1 = (double) contacts.get(0);
	       		final int zs2 = (int) contacts.get(1);
	       		boolean negativeHit = (boolean) contacts.get(2);
	       		if ( negativeHit ) {
	       			if ( zs1 > zb1 ) {
	       				negativeHit = false;
	       			} else if ( zs2 > zb2 ) {
	       				continue;
	       			}
	       		}
	       		
		       	if ( negativeHit ) {
		       		ray.x = aNegative.x - x;
		       		ray.y = aNegative.y - y;
		       		ray.z = aNegative.z - zs2;
		       	} else {
		       		ray.x = x - aPositive.x;
		       		ray.y = y - aPositive.y;
		       		ray.z = zb1 - aPositive.z;
		       	}
		       	ray.normalise();
		       	double rayComponent = ray.scalarProduct(aDirection);
		       	if ( rayComponent < 0 ) {
		       		rayComponent = 0;
		       	}
		       	int color = (int) ( 255 * ( Math.pow(rayComponent, aShadow) + aBrightness) / ( 1 + aBrightness ) );
		       	if ( color < 0 ) {
		       		color = 0;
		       	} else if ( color > 255 ) {
		       		color = 255;
		       	}
		       	result.setRGB(x - deltaX, y - deltaY, color);
		    }
		}
		return result;
	}	
	
	private static class Vector {
		
		public Vector(double aX, double aY, double aZ) {
			x = aX; y = aY; z = aZ;
		}
		
		public double scalarProduct(Vector aOther) {
			return x * aOther.x + y * aOther.y + z * aOther.z;
		}
		
		public Vector normalise() {
			final double magnitude = Math.sqrt(this.scalarProduct(this));
			return new Vector(x /= magnitude, y /= magnitude, z /= magnitude);
		}
		
		private double x, y, z;
		
	}
	
	private static class Sphere {
		
		public Sphere(int aX, int aY, int aZ, int aRadius) {
			x = aX; y = aY; z = aZ; radius = aRadius;
		}
		
		public List<Object> contact(int aX, int aY) {
			final int xx = aX - x;
			final int yy = aY - y;
			final int zSquared = radius * radius - ( xx * xx + yy * yy );
			if ( zSquared >= 0 ) {
				final double zz = Math.sqrt(zSquared);
				return List.of(z - zz, z, true);
			}
			return List.of( 0.0, 0, false );
		}	
		
		private int x, y, z, radius;
		
	}

}
