import java.util.HashMap;
import java.util.Map;

public final class BlumInteger {

	public static void main(String[] aArgs) {
		int[] blums = new int[50];
		int blumCount = 0;
		Map<Integer, Integer> lastDigitCounts = new HashMap<Integer, Integer>();
		int number = 1;
		
		while ( blumCount < 400_000 ) {			
			final int prime = leastPrimeFactor(number);
			if ( prime % 4 == 3 ) {
				final int quotient = number / prime;
				if ( quotient != prime && isPrimeType3(quotient) ) {
					if ( blumCount < 50 ) {
						blums[blumCount] = number;
					}
					lastDigitCounts.merge(number % 10, 1, Integer::sum);
					blumCount += 1;
					if ( blumCount == 50 ) {
						System.out.println("The first 50 Blum integers:");
						for ( int i = 0; i < 50; i++ ) {
							System.out.print(String.format("%3d", blums[i]));
							System.out.print(( i % 10 == 9 ) ? System.lineSeparator() : " ");
						}
						System.out.println();
					} else if ( blumCount == 26_828 || blumCount % 100_000 == 0 ) {
						System.out.println(String.format("%s%6d%s%7d",
							"The ", blumCount, "th Blum integer is: ", number));
						if ( blumCount == 400_000 ) {
							System.out.println();
							System.out.println("Percent distribution of the first 400000 Blum integers:");
							for ( int key : lastDigitCounts.keySet() ) {
		            			System.out.println(String.format("%s%6.3f%s%d",
		            				"    ", (double) lastDigitCounts.get(key) / 4_000, "% end in ", key));
							}
						}
					}
				}
			}
			number += ( number % 5 == 3 ) ? 4 : 2;
		}
	}
	
	private static boolean isPrimeType3(int aNumber) {
		if ( aNumber < 2 ) { return false; }
		if ( aNumber % 2 == 0 ) { return false; }
		if ( aNumber % 3 == 0 ) { return aNumber == 3; }

		for ( int divisor = 5; divisor * divisor <= aNumber; divisor += 2 ) {
			if ( aNumber % divisor == 0 ) { return false; }
		}		
		return aNumber % 4 == 3;
	}

	private static int leastPrimeFactor(int aNumber) {
		if ( aNumber == 1 ) { return 1; }
	    if ( aNumber % 3 == 0 ) { return 3; }
	    if ( aNumber % 5 == 0 ) { return 5; }
	
	    for ( int divisor = 7; divisor * divisor <= aNumber; divisor += 2 ) {
	    	if ( aNumber % divisor == 0 ) { return divisor; }
	    }	
		return aNumber;
	}

}
