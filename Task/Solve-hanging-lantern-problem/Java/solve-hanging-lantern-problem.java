import java.math.BigInteger;
import java.util.ArrayList;
import java.util.Collections;
import java.util.List;

public final class SolveHangingLanternProblem {

	public static void main(String[] args) {
		List<List<Integer>> tests = List.of(
			List.of( 1, 2, 3 ), List.of( 2, 2, 3, 3 ), List.of ( 100, 2 ) );
		
		System.out.println("Lantern arrangement => number of takedown ways:");
		tests.forEach( list -> System.out.println(list + " => " + takedownCount(list)) );
		System.out.println();
		
		takedownWays( new ArrayList<Integer>(List.of( 1, 2, 3 )), 5 );
	}
	
	private static BigInteger takedownCount(List<Integer> numbers) {
		final int total = numbers.stream().mapToInt(Integer::intValue).sum();
		BigInteger result = factorial(total);
		for ( int number : numbers ) {
			result = result.divide(factorial(number));
		}
		return result;
	}
	
	private static void takedownWays(List<Integer> numbers, int rowSize) {
		List<Integer> limits = new ArrayList<Integer>(Collections.nCopies(numbers.size(), 0));
	    int sum = 0;
	    List<Integer> multiNumbers = new ArrayList<Integer>();
	    for ( int i = 0; i < numbers.size(); i++ ) {
	        sum += numbers.get(i);
	        limits.set(i, sum);
	        for ( int j = 0; j < numbers.get(i); j++ ) {
	        	multiNumbers.addLast(i + 1);
	        }
	    }
	
	    final BigInteger takedownCount = takedownCount(numbers);
	    System.out.println("List of " + takedownCount + " permutations for " + numbers.size()
	    	+ " groups with lanterns per group " + numbers + " :");
	    int permutationCount = 0;
	    for ( List<Integer> permutation : permutations(multiNumbers) ) {
	        List<Integer> current = new ArrayList<Integer>(limits);
	        List<Integer> ways = new ArrayList<Integer>(Collections.nCopies(sum, 0));
	        for ( int i = 0; i < sum; i++ ) {
	            ways.set(i, current.get(permutation.get(i) - 1));
	            current.set(permutation.get(i) - 1, current.get(permutation.get(i) - 1) - 1);
	        }
	        System.out.print(ways + "  ");
	        permutationCount += 1;
	        if ( permutationCount % rowSize == 0 ) {
	        	System.out.println();
	        }
	    }
	}
		
	// Return the distinct permutations of a list possibly containing duplicates
	private static List<List<Integer>> permutations(List<Integer> numbers) {
	   List<List<Integer>> result = new ArrayList<List<Integer>>();
	   Collections.sort(numbers);
	   List<Boolean> used = new ArrayList<Boolean>(Collections.nCopies(numbers.size(), false));
	   backtrack(numbers, new ArrayList<Integer>(), used, result);
	   return result;
	}
	
	private static void backtrack(List<Integer> numbers, List<Integer> temp,
								  List<Boolean> used, List<List<Integer>> result) {
	    if ( temp.size() == numbers.size() ) {
	        result.addLast( new ArrayList<Integer>(temp) );
	    } else {
	        for ( int i = 0; i < numbers.size(); i++ ) {
	            if ( used.get(i) ||
 	            	( i > 0 && numbers.get(i) == numbers.get(i - 1) && ! used.get(i - 1) ) ) {
	            	continue;
	            }
	            used.set(i, true);
	            temp.addLast(numbers.get(i));
	            backtrack(numbers, temp, used, result);
	            used.set(i, false);
	            temp.removeLast();
	        }
	    }
	}
	
	private static BigInteger factorial(int n) {
		return ( n == 1 ) ? BigInteger.ONE : BigInteger.valueOf(n).multiply(factorial(n - 1));
	}
	
}
