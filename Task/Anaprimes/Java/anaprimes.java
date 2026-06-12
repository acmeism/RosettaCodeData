import java.util.ArrayList;
import java.util.Collections;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

public final class Anaprimes {

	public static void main(String[] args) {
		List<Integer> primes = listPrimeNumbers(1_000_001_000);		
		Map<List<Integer>, List<Integer>> anaprimes = new HashMap<List<Integer>, List<Integer>>();
		
		int index = 0;
		int limit = 1_000;
		while ( limit <= 1_000_000_000 ) {
			final int prime = primes.get(index++);
			if ( prime > limit ) {
				int maxLength = 0;
	            List<List<Integer>> groups = new ArrayList<List<Integer>>();
	            for ( List<Integer> value : anaprimes.values() ) {
	            	 if ( value.size() > maxLength ) {
	                     groups.clear();
	                     maxLength = value.size();
	                 }
	                 if ( value.size() == maxLength ) {
	                     groups.addLast(value);
	                 }
	            }
	
	            System.out.println(
	            	"Largest group(s) of anaprimes less than " + limit + " has " + maxLength + " members:");
			    for ( List<Integer> group : groups ) {
			        System.out.println("    First: " + group.getFirst() + ", Last: " + group.getLast());
			    }
			    System.out.println();
			    anaprimes.clear();
			    limit *= 10;				
			}
			anaprimes.computeIfAbsent(digits(prime), v -> new ArrayList<Integer>() ).addLast(prime);
		}
	}
	
	private static List<Integer> digits(int number) {
	    List<Integer> result = new ArrayList<Integer>();
	    while ( number > 0 ) {
	        result.addLast(number % 10);
	        number /= 10;
	    }
	    Collections.sort(result);
	    return result;
	}
	
	private static List<Integer> listPrimeNumbers(int limit) {
		List<Integer> primes = new ArrayList<Integer>();
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
		return primes;
	}	

}
