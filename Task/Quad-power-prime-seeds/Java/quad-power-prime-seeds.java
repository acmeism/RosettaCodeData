import java.math.BigInteger;

public final class QuadPowerPrimeSeeds {

	public static void main(String[] args) {
		System.out.println("The first 50 quad-power prime seeds:");
		int index = 0;
		int number = 1;
		while ( index < 50 ) {
			if ( isQuadPowerPrimeSeed(number) ) {
				index += 1;
				System.out.print(String.format("%7d%s", number, ( index % 10 == 0 ? "\n" : " " )));
			}
			number += 1;
		}		
		System.out.println();
		
		System.out.println("The first quad-power prime seed greater than:");
		int multiple = 1;
		while ( multiple <= 3 ) {
		    if ( isQuadPowerPrimeSeed(number) ) {
		        index += 1;
		        if ( number > multiple * 1_000_000 ) {
		            System.out.println("    " + multiple + " million is " + number + " at index " + index);
		            multiple += 1;
		        }
		    }
		    number += 1;
		}
	}
	
	private static boolean isQuadPowerPrimeSeed(long number) {
		BigInteger p = BigInteger.valueOf(number);
		BigInteger nPlus1 = BigInteger.valueOf(number + 1);
		for ( int i = 1; i <= 4; i++ ) {
			if ( ! p.add(nPlus1).isProbablePrime(15) ) {
				return false;
			}
			p = p.multiply(BigInteger.valueOf(number));
		}
		return true;
	}

}
