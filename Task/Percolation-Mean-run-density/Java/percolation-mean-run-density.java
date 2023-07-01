import java.util.concurrent.ThreadLocalRandom;

public final class PercolationMeanRun {

	public static void main(String[] aArgs) {
		System.out.println("Running 1000 tests each:" + System.lineSeparator());
		System.out.println(" p\tlength\tresult\ttheory\t   difference");
		System.out.println("-".repeat(48));
		
	    for ( double probability = 0.1; probability <= 0.9; probability += 0.2 ) {
	        double theory = probability * ( 1.0 - probability );
	        int length = 100;
	        while ( length <= 100_000 ) {
	            double result = runTest(probability, length, 1_000);
	            System.out.println(String.format("%.1f\t%6d\t%.4f\t%.4f\t%+.4f (%+.2f%%)",
	            	probability, length, result, theory, result - theory, ( result - theory ) / theory * 100));
	            length *= 10;
	        }
	        System.out.println();
	    }

	}
	
	private static double runTest(double aProbability, int aLength, int aRunCount) {
		double count = 0.0;
	    for ( int run = 0; run < aRunCount; run++ ) {
	        int previousBit = 0;
	        int length = aLength;
	        while ( length-- > 0 ) {
	            int nextBit = ( random.nextDouble(1.0) < aProbability ) ? 1 : 0;
	            if ( previousBit < nextBit ) {
	            	count += 1.0;
	            }
	            previousBit = nextBit;
	        }
	    }
	    return count / aRunCount / aLength;
	}

	private static ThreadLocalRandom random = ThreadLocalRandom.current();

}
