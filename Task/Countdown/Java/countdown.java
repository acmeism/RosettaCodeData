import java.util.ArrayList;
import java.util.Collections;
import java.util.List;
import java.util.concurrent.ThreadLocalRandom;

public final class Countdown {

	public static void main(String[] args) {
		List<Integer> allNumbers = new ArrayList<Integer>(List.of(
			1, 1, 2, 2, 3, 3, 4, 4, 5, 5, 6, 6, 7, 7, 8, 8, 9, 9, 10, 10, 25, 50, 75, 100 ));
		
		ThreadLocalRandom random = ThreadLocalRandom.current();
		Collections.shuffle(allNumbers);
		
		List<List<Integer>> numberLists = List.of(
		    List.of( 3, 6, 25, 50, 75, 100 ),
		    List.of( 100, 75, 50, 25, 6, 3 ),
		    List.of( 8, 4, 4, 6, 8, 9 ),
		    allNumbers.subList(0, 6)
		);
		
		List<Integer> targetList = List.of( 952, 952, 594, random.nextInt(101, 1000) );
		for ( int i = 0; i < targetList.size(); i++ ) {
		    System.out.println("Using : " + numberLists.get(i));
		    System.out.println("Target: " + targetList.get(i));
		    final boolean done = countdown(numberLists.get(i), targetList.get(i));
		    if ( ! done ) {
		    	System.out.println("No solution found");
		    }
		    System.out.println();
		}
	}	
	
	private static boolean countdown(List<Integer> numbers, int target) {
	    if ( numbers.size() <= 1 ) {
	    	return false;
	    }
	
	    for ( int n0 : numbers ) {
	        List<Integer> numbers1 = new ArrayList<Integer>(numbers);
	        numbers1.remove(Integer.valueOf(n0));
	        for ( int n1 : numbers1 ) {
	            List<Integer> numbers2 = new ArrayList<Integer>(numbers1);
	            numbers2.remove(Integer.valueOf(n1));	
	            if ( n1 >= n0 ) {
	                int result = n1 + n0;
	                List<Integer> numbersNext = new ArrayList<Integer>(numbers2);
	                numbersNext.addLast(result);
	                if ( result == target || countdown(numbersNext, target) ) {
	                    System.out.println(result + " = " + n1 + " + " + n0);
	                    return true;
	                }
	
	                if ( n0 != 1 ) {
	                    result = n1 * n0;
	                    numbersNext = new ArrayList<Integer>(numbers2);
	                    numbersNext.addLast(result);
	                    if ( result == target || countdown(numbersNext, target) ) {
	                        System.out.println(result + " = " + n1 + " * " + n0);
	                        return true;
	                    }
	                }
	
	                if ( n1 != n0 ) {
	                    result = n1 - n0;
	                    numbersNext = new ArrayList<Integer>(numbers2);
	                    numbersNext.addLast(result);
	                    if ( result == target || countdown(numbersNext, target) ) {
	                    	System.out.println(result + " = " + n1 + " - " + n0);
	                        return true;
	                    }
	                }
	
	                if ( n0 != 1 && n1 % n0 == 0 ) {
	                    result = n1 / n0;
	                    numbersNext = new ArrayList<Integer>(numbers2);
	                    numbersNext.addLast(result);
	                    if ( result == target || countdown(numbersNext, target) ) {
	                    	System.out.println(result + " = " + n1 + " / " + n0);
	                        return true;
	                    }
	                }
	            }
	        }
	    }
	    return false;
	}
	
}
