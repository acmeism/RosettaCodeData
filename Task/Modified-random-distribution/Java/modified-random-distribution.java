import java.util.List;
import java.util.concurrent.ThreadLocalRandom;
import java.util.stream.Stream;

interface ModifierInterface {	
	double modifier(double aDouble);	
}

public final class ModifiedRandomDistribution222 {

	public static void main(String[] aArgs) {
		final int sampleSize = 100_000;
		final int binCount = 20;
		final double binSize = 1.0 / binCount;
		
		List<Integer> bins = Stream.generate( () -> 0 ).limit(binCount).toList();
		
	    for ( int i = 0; i < sampleSize; i++ ) {
	    	double random = modifiedRandom(modifier);
	        int binNumber = (int) Math.floor(random / binSize);
	        bins.set(binNumber, bins.get(binNumber) + 1);
	    }
		
		System.out.println("Modified random distribution with " + sampleSize + " samples in range [0, 1):");
		System.out.println();
		System.out.println("    Range           		  Number of samples within range");
		
		final int scaleFactor = 125;
		for ( int i = 0; i < binCount; i++ ) {
			String histogram = String.valueOf("#").repeat(bins.get(i) / scaleFactor);
			System.out.println(String.format("%4.2f ..< %4.2f %s %s",
				(float) i / binCount, (float) ( i + 1.0 ) / binCount, histogram, bins.get(i)));			
		}		
	}
	
	private static double modifiedRandom(ModifierInterface aModifier) {
		double result = -1.0;
		
		while ( result < 0.0 ) {
			double randomOne = RANDOM.nextDouble();
			double randomTwo = RANDOM.nextDouble();
			if ( randomTwo < aModifier.modifier(randomOne) ) {
				result = randomOne;
			}
		}
		
		return result;		
	}		
	
	private static ModifierInterface modifier = aX -> ( aX < 0.5 ) ? 2 * ( 0.5 - aX ) : 2 * ( aX - 0.5 );	
	
	private static final ThreadLocalRandom RANDOM = ThreadLocalRandom.current();

}
