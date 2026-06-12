import java.math.BigInteger;

public final class LeastMSuchThatNFactorialPlusMIsPrime {

	public static void main(String[] args) {
		int index = 0;
		BigInteger factorial = BigInteger.ONE;
		boolean working = true;
		System.out.println("The least positive integer m such that n! + m is prime; first 50:");
		while ( working ) {
			final int m = nextPrime(factorial).subtract(factorial).intValueExact();
			if ( index <= 49 ) {
				System.out.print(String.format("%3d%s", m, ( index % 10 == 9 ? "\n" : " " )));
			} else if ( index == 50 ) {
				System.out.println();
			} else if ( m > 1_000 ) {
				System.out.println("The first m > 1,000 is " + m + " at index " + index);
				working = false;
			}
			
			index += 1;
			factorial = factorial.multiply(BigInteger.valueOf(index));
		}
	}
	
	private static BigInteger nextPrime(BigInteger factorial) {
		if ( factorial.equals(BigInteger.ONE) ) {
			return BigInteger.TWO;
		}

		if ( ! factorial.testBit(0) && ( factorial = factorial.add(BigInteger.ONE) ).isProbablePrime(10) ) {
			return factorial;
		}	
		
		factorial = factorial.add(BigInteger.TWO);
		while ( ! factorial.isProbablePrime(10) ) {
			factorial = factorial.add(BigInteger.TWO);
		}	
		return factorial;
	}

}
