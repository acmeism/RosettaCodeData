import java.util.ArrayList;
import java.util.Collections;
import java.util.List;

public final class NumbersNotSumDistinctSquares {

	public static void main(String[] aArgs) {
		List<Integer> squares = new ArrayList<Integer>();
		List<Integer> result = new ArrayList<Integer>();
	    int testNumber = 1;
	    int previousTestNumber = 1;
	    while ( previousTestNumber >= ( testNumber >> 1 ) ) {
	        final int squareRoot = (int) Math.sqrt(testNumber);
	        if ( squareRoot * squareRoot == testNumber ) {
	            squares.add(testNumber);
	        }
	        if ( ! sumOfDistinctSquares(testNumber, squares) ) {	
	            result.add(testNumber);
	            previousTestNumber = testNumber;
	        }
	        testNumber += 1;
	    }
	
	    System.out.println("Numbers which are not the sum of distinct squares:");
	    System.out.println(result);
	    System.out.println();
	    System.out.println("Stopped checking after finding " + ( testNumber - previousTestNumber )
	    	+ " sequential non-gaps after the final gap of " + previousTestNumber);
	    System.out.println("Found " + result.size() + " numbers in total");
	}
	
	private static boolean sumOfDistinctSquares(int aN, List<Integer> aSquares) {
		if ( aN <= 0 ) {
			return false;
		}
		if ( aSquares.contains(aN) ) {
			return true;
		}
		
		final int sum = aSquares.stream().mapToInt(Integer::intValue).sum();
		if ( aN > sum ) {
	        return false;
	    }
	    if ( aN == sum ) {
	        return true;
	    }
	
	    List<Integer> reversedSquares = new ArrayList<Integer>(aSquares);
	    reversedSquares.remove(reversedSquares.size() - 1);
	    Collections.reverse(reversedSquares);
	
	    return sumOfDistinctSquares(aN - aSquares.get(aSquares.size() - 1), reversedSquares)
	    	|| sumOfDistinctSquares(aN, reversedSquares);
	}

}
