import module java.base;

public final class LucasCarmichaelNumbers {

	public static void main() {
		IO.println("Least Lucas-Carmichael number with n prime factors:");
		for ( int n = 3; n <= 12; n++ ) {
		    IO.println("%2d:%20d".formatted(n, lucasCarmichaelWithNPrimes(n)));
		}
		
		IO.println("\nNumber of Lucas-Carmichael numbers less than 10^n:");
		int accumulator = 0;
		for ( int n = 1; n <= 10; n++ ) {
		    accumulator += LCCount((long) Math.pow(10, n - 1), (long) Math.pow(10, n));
		    IO.println("%2d:%5d".formatted(n, accumulator));
		}		
	}
	
	private static long lucasCarmichaelWithNPrimes(int n) {
		 if ( n < 3 ) {
			 return 0;
		 }
		
	    long x = primorial(( n + 1 ) / 2);
	    long y = 2 * x;
	    long minLC = 0;
	
	    while ( true ) {
	        List<Long> numbersLC = new ArrayList<Long>();
	        LCInRange(x, y, n, numbersLC);
	
	        for ( long number : numbersLC ) {
	            if ( minLC == 0 || minLC > number ) {
	            	minLC = number;
	            }
	        }
	
	        if ( minLC > 0 ) {
	        	return minLC;
	        }
	
	        x = y + 1;
	        y = 2 * x;
	    }	
	}
	
	private static int LCCount(long A, long B) {
	    List<Long> numbersLC = new ArrayList<Long>();
	    int k = 3;
	
	    while ( k <= 8 ) {
	        if ( primorial(k + 1) / 2 > B ) {
	        	break;
	        }
	
	        LCInRange(A, B, k, numbersLC);
	        k += 1;
	    }
	
	    return numbersLC.size();
	}
	
	private static void LCInRange(long A, long B, int k, List<Long> numbersLC) {
		final long maxP = (long) Math.sqrt(B + 1) - 1;
		A = Math.max(primorial(k + 1) / 2, A);
		processLevel(1, 1, 3, A, B, k, maxP, numbersLC);
	}
	
	private static void processLevel(long m, long L, long lo,
			                         long A, long B, long k, long maxP, List<Long> numbersLC) {
		
	    long hi = Math.round(Math.pow(B / m, 1.0 / k));
	    if ( lo > hi ) {
	    	return;
	    }
	
	    if ( k == 1 ) {
	        hi = Math.min(maxP, hi);
	        lo = Math.max((long) Math.ceil(A / m), lo);
	        if ( lo > hi ) {
	        	return;
	        }
	
	        long temp = L - modularInverse(m, L);
	        while ( temp < lo ) {
	        	temp += L;
	        }
	
	        for ( long p = temp; p <= hi; p += L ) {
	            if ( isPrime(p) ) {
	                final long n = m * p;
	                if ( ( n + 1 ) % ( p + 1 ) == 0 ) {
	                    numbersLC.addLast(n);
	                }
	            }
	        }
	    } else {
	        for ( long p = lo; p <= hi; p++ ) {
		        if ( isPrime(p) && gcd(m, p + 1) == 1 ) {
		            processLevel(m * p, lcm(L, p + 1), p + 1, A, B, k - 1, maxP, numbersLC);
		        }
	        }
	    }	
	}
	
	private static long modularInverse(long a, long m) {
		return BigInteger.valueOf(a).modInverse(BigInteger.valueOf(m)).longValue();
	}
	
	private static long gcd(long n, long d) {
		return ( d == 0 ) ? n : gcd(d, n % d);
	}
	
	private static long lcm(long r, long s) {
		return ( r * s ) / gcd(r, s);
	}
	
	private static long primorial(int n) {
		return IntStream.rangeClosed(2, n).filter( i -> isPrime(i) ).reduce(1, (a, b) -> a * b );
	}
	
	private static boolean isPrime(long n) {
		return BigInteger.valueOf(n).isProbablePrime(15);
	}

}
