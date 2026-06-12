import java.util.ArrayList;
import java.util.List;
import java.util.stream.Collectors;

public final class FermatPseudoprimes {

	public static void main(String[] args) {
		final int limit = 50_000;

		for ( int base = 1; base <= 20; base++ ) {
			int count = 0;
			List<Integer> firstTwenty = new ArrayList<Integer>();
			for ( int number = 4; number <= limit; number++ ) {
				if ( isFermatPseudoprime(base, number) ) {
					count += 1;
					if ( count <= 20 ) {
						firstTwenty.addLast(number);
					}
				}
			}
			
			System.out.println("Base " + base + ":");
			System.out.println("    The number of Fermat pseudoprimes up to " + limit + ": " + count);
			System.out.println("    The first 20: " +
				firstTwenty.stream().map(String::valueOf).collect(Collectors.joining(" ")));
		}
	}	

	private static boolean isFermatPseudoprime(int base, int number) {
	    return ! isPrime(number) && moduloPower(base, number - 1, number) == 1;
	}
	
	private static long moduloPower(long base, long exponent, long modulus) {
	    if ( modulus == 1 ) {
	        return 0;
	    }
	
	    base %= modulus;
	    long result = 1;	
	    while ( exponent > 0 ) {
	        if ( ( exponent & 1 ) == 1 ) {
	            result = ( result * base ) % modulus;
	        }
	        base = ( base * base ) % modulus;
	        exponent >>= 1;
	    }
	
	    return result;
	}

	private static boolean isPrime(int number) {
	    if ( number < 2 ) {
	        return false;
	    }
	    if ( number % 2 == 0 ) {
	        return number == 2;
	    }
	    if ( number % 3 == 0 ) {
	        return number == 3;
	    }
	
	    for ( int p = 5; p * p <= number; p += 4 ) {
	        if ( number % p == 0 ) {
	            return false;
	        }
	        p += 2;
	        if ( number % p == 0 ) {
	            return false;
	        }
	    }

	    return true;
	}
	
}
