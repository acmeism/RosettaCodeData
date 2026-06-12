import java.util.ArrayList;
import java.util.Comparator;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Set;
import java.util.TreeSet;

public final class FactorPerfectNumbers {

	public static void main(String[] args) {
		final int test = 48;
		
		List<Integer> singleton = new ArrayList<Integer>();	
		singleton.addLast(1);
		List<List<Integer>> multiples = moreMultiples(singleton, divisors(test));		
		
		Set<List<Integer>> result = new TreeSet<List<Integer>>(customComparator);
		for ( List<Integer> list : multiples ) {
			if ( list.getLast() != test ) {
				list.addLast(test);
			}
			result.add(list);
		}		
		
		System.out.println(result.size() + " sequences using the first definition:");
		int count = 0;
		for ( List<Integer> list : result ) {
			System.out.print(String.format("%-23s%s", list, ( count++ % 4 == 3 ? "\n" : " " )));			
		}	
		System.out.println();
		
		System.out.println(result.size() + " sequences using the second definition:");
		for ( List<Integer> list : result ) {
			for ( int i = 1; i < list.size(); i++ ) {
                list.set(i - 1, list.get(i) / list.get(i - 1));
			}
			list.removeLast();
		}
		
		count = 0;
		for ( List<Integer> list : result ) {
			System.out.print(String.format("%-23s%s", list, ( count++ % 4 == 3 ? "\n" : " " )));			
		}	
		System.out.println();
		
		System.out.print("OEIS A163272: 0 1 ");
        for ( int n = 2; n < 2_400_000; n++ ) {
            if ( erdösFactorCount(n) == n ) {
            	System.out.print(n + " ");
            }
        }
        System.out.println();
	}
	
	private static int erdösFactorCount(int number) {
		if ( ! cache.containsKey(number) ) {
			int factorCount = 0;
		    List<Integer> divisors = divisors(number);		
		    for ( int i = 1; i < divisors.size() - 1; i++ ) {
		        factorCount += erdösFactorCount(number / divisors.get(i));
		    }		
		    factorCount += 1;
		    cache.put(number, factorCount);
		}
		
		return cache.get(number);
	}
	
	private static List<List<Integer>> moreMultiples(List<Integer> toList, List<Integer> fromList) {
	    List<List<Integer>> result = new ArrayList<List<Integer>>();
	
	    for ( int from : fromList ) {
	       if ( from > toList.getLast() && from % toList.getLast() == 0 ) {
	    	   List<Integer> toListCopy = new ArrayList<Integer>(toList);
	    	   toListCopy.addLast(from);
	    	   result.add(toListCopy);
	       }
	    }
	
	    List<List<Integer>> resultCopy = new ArrayList<List<Integer>>(result);
	    for ( List<Integer> list : resultCopy ) {
	        for ( List<Integer> more : moreMultiples(list, fromList) ) {
	            result.add(more);
	        }
	    }

	    return result;
	}
	
	private static List<Integer> divisors(int number) {
		Set<Integer> divisors = new TreeSet<Integer>();

	    int divisor = 1;
	    while ( divisor * divisor <= number ) {	    	
	        if ( number % divisor == 0 ) {
	        	divisors.add(divisor);
	        	divisors.add(number / divisor);
	        }
	        divisor += 1;	
	    }
	
	    return new ArrayList<Integer>(divisors);
	}
	
	private static Comparator<List<Integer>> customComparator = (one, two) -> {
		for ( int i = 0; i < Math.min(one.size(), two.size()); i++ ) {
			final int comparison = Integer.compare(one.get(i), two.get(i));
			if ( comparison != 0 ) {
				return comparison;
			}
		}
		
		return Integer.compare(one.size(), two.size());
	};
	
	private static Map<Integer, Integer> cache = new HashMap<Integer, Integer>();

}
