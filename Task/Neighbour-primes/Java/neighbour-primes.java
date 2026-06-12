import java.util.ArrayList;
import java.util.Collections;
import java.util.List;

public final class NeighbourPrimes {

	public static void main(String[] args) {
		listPrimeNumbers(251_000); // 499 * 499 = 249,001
		
		System.out.print("Neighbour primes less than 500: ");
		int i = 0;
		int p = primes.get(i);
		while ( p < 500 ) {
		    i += 1;
		    int q = primes.get(i);
		    if ( Collections.binarySearch(primes, ( p * q + 2 )) > 0 ) {
		    	System.out.print(p + " ");
		    }
		    p = q;
		}
		System.out.println();
	}
	
	private static void listPrimeNumbers(int limit) {
		primes = new ArrayList<Integer>();
		primes.add(2);
		final int halfLimit = ( limit + 1 ) / 2;
		boolean[] composite = new boolean[halfLimit];
		for ( int i = 1, p = 3; i < halfLimit; p += 2, i++ ) {
			if ( ! composite[i] ) {
				primes.add(p);
				for ( int a = i + p; a < halfLimit; a += p ) {
					composite[a] = true;
				}
			}
		}
	}	
	
	private static List<Integer> primes;

}
