import java.math.BigInteger;

public final class PentaPowerPrimeSeeds {

	public static void main(String[] args) {
		System.out.println("The first 30 penta-power prime seeds:");
		int index = 0;
		int number = 1;
		boolean searching = true;
		while ( searching ) {
		    if ( isPentaPowerPrimeSeed(number) ) {
		    	index += 1;
		    	if ( index <= 30 ) {
		    		System.out.print(String.format("%7d%s", number, ( index % 6 == 0 ? "\n" : " " )));
		    	} else if ( number > 10_000_000 ) {
		    		System.out.println();
		    		System.out.println("The first penta-power prime seed greater than 10,000,000 is "
		    			+ number + " at index " + index);
		    		searching = false;
		    	}
		    }
		    number += 2;
		}
	}
	
	private static boolean isPentaPowerPrimeSeed(long number) {
		BigInteger p = BigInteger.ONE;
		BigInteger nPlus1 = BigInteger.valueOf(number + 1);
		for ( int i = 0; i <= 4; i++ ) {
			if ( ! p.add(nPlus1).isProbablePrime(15) ) {
				return false;
			}
			p = p.multiply(BigInteger.valueOf(number));
		}
		return true;
	}

}
