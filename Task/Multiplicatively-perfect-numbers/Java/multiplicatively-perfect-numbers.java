public final class MultiplicativelyPerfectNumbers {

	public static void main(String[] args) {
		int count = 0;
		for ( int i = 1; i < 500; i++ ) {
			if ( isMPN(i) ) {
				count += 1;
				System.out.print(String.format("%3d%s", i, ( count % 10 == 0 ? "\n" : " " )));
			}
		}
		System.out.println();		
		
		int mpnCount = 0;
		int limit = 500;
		int ns = 3;
		int nc = 3;
		int squares = 1;
		int cubes = 1;
		int n = 0;
		while ( true ) {
			n += 1;
			if ( n == limit ) {
				while ( ns * ns < limit ) {
					if ( isPrime(ns) ) {
						squares += 1;
					}
					ns += 2;
				}
				while ( nc * nc * nc < limit ) {
					if ( isPrime(nc) ) {
						cubes += 1;
					}
					nc += 2;
				}
			System.out.println("Under " + limit + " there are " + mpnCount + " MPNs and "
				+ ( mpnCount - cubes + squares ) + " semi-primes.");
		    if ( limit == 500_000 ) {
		    	break;
		    }
		    limit *= 10;
		}
		if ( isMPN(n) ) {
			mpnCount += 1;
		}
	}

}
	
	private static boolean isMPN(int number) {
		if ( number == 1 ) { // Counting 1 as an MPN in accordance with www.oeis.net/A007422
			return true;
		}
		
		final int delta = 1 + ( number & 1 );		
		int d = delta + 1;
		int firstDivisor = 0;
		int secondDivisor = 0;
		while ( d * d <= number ) {
			if ( number % d == 0 ) {
				if ( secondDivisor != 0 ) { // From www.oeis.net/A007422, an MPN
					return false;           // cannot have more than two proper divisors
				}
				firstDivisor = d;
				final int q = number / d;
				if ( q != d ) {
					secondDivisor = q;
				}
			}
			d += delta;
		}
		return firstDivisor * secondDivisor == number;
	}

	private static boolean isPrime(int n) {
		if ( n < 2 ) {
			return false;
		}
		if ( n % 2 == 0 ) {
			return n == 2;
		}
		if ( n % 3 == 0 ) {
			return n == 3;
		}
		
		int k = 5;
		int delta = 2;
		while ( k * k <= n ) {
			if ( n % k == 0 ) {
				return false;
			}
			k += delta;
			delta = 6 - delta;
		}
		return true;
	}

}
