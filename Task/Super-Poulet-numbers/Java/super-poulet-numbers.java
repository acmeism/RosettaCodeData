import java.util.Set;
import java.util.TreeSet;

public final class SuperPouletNumbers {

	public static void main(String[] args) {
		int n = 2;
		int count = 0;
		boolean searching = true;
		while ( searching ) {
		    if ( isSuperPouletNumber(n) ) {
		    	count += 1;
		    	if ( count <= 20 ) {
		    		System.out.print(String.format("%6d%s", n, ( count % 5 == 0 ? "\n" : " " )));
		    	} else if ( n > 1_000_000 ) {
		    		System.out.println(System.lineSeparator() +
		    			"The first super-Poulet number greater than one million is " + n + " at index " + count);
		    		searching = false;
		    	}
		    }
		    n += 1;
		}		
	}	
	
	private static boolean isSuperPouletNumber(int number) {
		if ( isPrime(number) || modulusPower(2, number - 1, number) != 1 ) {
			return false;
		}
		
		for ( int divisor : divisors(number) ) {
			if ( modulusPower(2, divisor, divisor) != 2 ) {
				return false;
			}
		}
		return true;
	}
	
	// Return the divisors of the given number, excluding 1
	private static Set<Integer> divisors(int number) {
		Set<Integer> result = new TreeSet<Integer>();
		for ( int d = 2; d * d <= number; d++ ) {
	        if ( number % d == 0 ) {
	        	result.add(d);
	            result.add(number / d);
	        }
	    }
		result.add(number);
		return result;
	}
	
	private static long modulusPower(long base, long exponent, long modulus) {
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
		
		int delta = 2;
		int k = 5;
		while ( k * k <= number ) {
		    if ( number % k == 0 ) {
		    	return false;
		    }
		    k += delta;
		    delta = 6 - delta;
		}
		return true;
	}

}
