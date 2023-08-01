import java.awt.Color;
import java.awt.Graphics;
import java.awt.image.BufferedImage;
import java.io.File;
import java.io.IOException;
import java.util.List;

import javax.imageio.ImageIO;

public final class GoldbachsComet {

	public static void main(String[] aArgs) {
		initialisePrimes(2_000_000);		
		
		System.out.println("The first 100 Goldbach numbers:");
		for ( int n = 2; n < 102; n++ ) {
			System.out.print(String.format("%3d%s", goldbachFunction(2 * n), ( n % 10 == 1 ? "\n" : "" )));
		}
		
		System.out.println();
		System.out.println("The 1,000,000th Goldbach number = " + goldbachFunction(1_000_000));
		
		createImage();
	}	
	
	private static void createImage() {
		final int width = 1040;
		final int height = 860;
		BufferedImage image = new BufferedImage(width, height, BufferedImage.TYPE_INT_RGB);
		Graphics graphics = image.getGraphics();
        graphics.setColor(Color.WHITE);
        graphics.fillRect(0, 0, width, height);
		
        List<Color> colours = List.of( Color.BLUE, Color.GREEN, Color.RED );
        for ( int n = 2; n < 2002; n++ ) {
        	graphics.setColor(colours.get(n % 3));
        	graphics.fillOval(n / 2, height - 5 * goldbachFunction(2 * n), 10, 10);
        }		
		
		try {
			ImageIO.write(image, "png", new File("GoldbachsCometJava.png"));
		} catch (IOException ioe) {
			ioe.printStackTrace();
		}
	}
	
	private static int goldbachFunction(int aNumber) {
		if (  aNumber <= 2 || aNumber % 2 == 1 ) {
			throw new AssertionError("Argument must be even and greater than 2: " + aNumber);
		}
		
		int result = 0;
		for ( int i = 1; i <= aNumber / 2; i++ ) {			
		    if ( primes[i] && primes[aNumber - i] ) {
		    	result += 1;
		    }
		}
		return result;
	}
	
	private static void initialisePrimes(int aLimit) {
		primes = new boolean[aLimit];
		for ( int i = 2; i < aLimit; i++ ) {
			primes[i] = true;
		}
		
		for ( int n = 2; n < Math.sqrt(aLimit); n++ ) {
			for ( int k = n * n; k < aLimit; k += n ) {
				primes[k] = false;
			}
		}
	}
	
	private static boolean[] primes;

}
