import java.util.ArrayList;
import java.util.List;
import java.util.Set;
import java.util.TreeSet;

public final class ConcatenateTwoPrimesIsAlsoPrime {

	public static void main(String[] args) {
		initialisePrimes(99);
		Set<Integer> concatenated = new TreeSet<Integer>();
		for ( int a : primes ) {
			for ( int b : primes ) {
				final int n = concatenate(a, b);
				if ( isPrime(n) ) {
					concatenated.add(n);
				}
			}
		}
		
		System.out.println("There are " + concatenated.size( ) + " concatenated primes "
			+ "with each part less than 100:");	
		concatenated.forEach( i -> System.out.print(i + " ") );
	}
	
	private static void initialisePrimes(int limit) {
	    primes.addLast(2);
	    for ( int i = 3; i <= limit; i += 2 ) {
	    	if ( isPrime(i) ) {
	    		primes.addLast(i);	
	    	}
	    }
	}
	
	private static int concatenate(int one , int two) {		
		return Integer.valueOf(String.valueOf(one) + String.valueOf(two));
	}
	
	private static boolean isPrime(int number) {
	    if ( number % 2 == 0 ) {
	    	return number == 2;
	    }
	    int k = 3;
	    while ( k * k <= number ) {
	    	if ( number % k == 0 ) {
	    		return false;
	    	}
	    	k += 2;
	    }
	    return true;
	}
	
	private static List<Integer> primes = new ArrayList<Integer>();

}
