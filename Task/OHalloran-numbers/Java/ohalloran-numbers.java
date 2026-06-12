import java.util.Arrays;

public final class OHalloranNumbers {

	public static void main(String[] args) {
		final int maximumArea = 1_000;
		final int halfMaximumArea = maximumArea / 2;
		
		boolean[] ohalloranNumbers = new boolean[halfMaximumArea];
		Arrays.fill(ohalloranNumbers, true);
				
		for ( int length = 1; length < maximumArea; length++ ) {
		    for ( int width = 1; width < halfMaximumArea; width++ ) {
		        for ( int height = 1; height < halfMaximumArea; height++ ) {
		            int halfArea = length * width + length * height + width * height;
		            if ( halfArea < halfMaximumArea ) {
		                ohalloranNumbers[halfArea] = false;
		            }
		        }
		    }
		}
		
		System.out.println("Values larger than 6 and less tha 1_000 which cannot be the surface area of a cuboid:");
		for ( int i = 3; i < halfMaximumArea; i++ ) {
		    if ( ohalloranNumbers[i] ) {
		        System.out.print(i * 2 + " ");
		    }
		}
		System.out.println();
	}

}
