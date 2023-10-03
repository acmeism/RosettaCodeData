import java.math.BigInteger;
import java.util.List;
import java.util.concurrent.ThreadLocalRandom;

public final class SquareFormFactorization {

	public static void main(String[] args) {		
		ThreadLocalRandom random = ThreadLocalRandom.current();
		final long lowerLimit = 10_000_000_000_000_000L;
		final List<Long> tests = random.longs(20, lowerLimit, 10 * lowerLimit).boxed().toList();

	    for ( long test : tests ) {
	        long factor = squfof(test);	

	        if ( factor == 0 ) {
	        	System.out.println(test + " - failed to factorise");
	        } else if ( factor == 1 ) {
	        	System.out.println(test + " is a prime number");
	        } else {
	        	System.out.println(test + " = " + factor + " * " + test / factor);
	        }
	        System.out.println();
	   }
	}
	
	private static long squfof(long number) {
		if ( BigInteger.valueOf(number).isProbablePrime(15) ) {
	    	return 1; // Prime number
	    }
		
	    final int sqrt = (int) Math.sqrt(number);
	    if ( sqrt * sqrt == number ) {
	    	return sqrt;
	    }	
	
        testValue = number;
        sqrtTestValue = (long) Math.sqrt(testValue);

        // Principal form
        BQF form = new BQF(0, sqrtTestValue, 1);
        form = form.rhoInverse();

		// Search principal cycle
		for ( int i = 0; i < 4 * (long) Math.sqrt(2 * sqrtTestValue); i += 2 ) {
			// Even step
			form = form.rho();				

			long sqrtC = (long) Math.sqrt(form.c);
			if ( sqrtC * sqrtC == form.c ) { // Square form found
				// Inverse square root
				BQF formInverse = new BQF(0, -form.b, sqrtC);
				formInverse = formInverse.rhoInverse();

				// Search ambiguous cycle
				long previousB = 0;
				do {
					previousB = formInverse.b;
					formInverse = formInverse.rho();
				} while ( formInverse.b != previousB );
				
				// Symmetry point
				final long gcd = gcd(number, formInverse.a);
				if ( gcd != 1 ) {
					return gcd;
				}
			}
			
			// Odd step
			form = form.rho();				
		}
		
		if ( number % 2 == 0 ) {
			return 2;
		}	
		return 0; // Failed to factorise
	}

	private static long gcd(long a, long b) {
		while ( b != 0 ) {
			long temp = a; a = b; b = temp % b;
		}
		return a;
	}	
	
	private static class BQF { // Binary quadratic form
		
		public BQF(long aA, long aB, long aC) {
			a = aA; b = aB; c = aC;
			q = ( sqrtTestValue + b ) / c;
			bb = q * c - b;
		}
		
		public BQF rho() {
			return new BQF(c, bb, a  + q * ( b - bb ));		
		}
		
		public BQF rhoInverse() {
			return new BQF(c, bb, ( testValue - bb * bb ) / c);
		}
		
		private long a, b, c;
		private long q, bb;
		
	}
	
	private static long testValue, sqrtTestValue;

}
