import java.util.ArrayList;
import java.util.Arrays;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.function.Function;
import java.util.stream.Collectors;
import java.util.stream.IntStream;

public final class WastefulEquidigitalAndFrugalNumbers {

	public static void main(String[] args) {
		createFactors(2_700_000);
		
		final int tinyLimit = 50;
		final int lowerLimit = 10_000;
		final int upperLimit = 1_000_000;		
		
		for ( int base : List.of( 10, 11 ) ) {				
			Map<Category, Count> counts = Arrays.stream(Category.values())
				.collect(Collectors.toMap( Function.identity(), value -> new Count(0, 0) ));
			Map<Category, List<Integer>> lists = Arrays.stream(Category.values())
				.collect(Collectors.toMap( Function.identity(), value -> new ArrayList<Integer>() ));		
			
		    int number = 1;
		    System.out.println("FOR BASE " + base + ":" + System.lineSeparator());
		    while ( counts.values().stream().anyMatch( count -> count.lowerCount < lowerLimit ) ) {
		    	Category category = category(number, base);
		    	Count count = counts.get(category);
		    	if ( count.lowerCount < tinyLimit || count.lowerCount == lowerLimit - 1 ) {
		    		lists.get(category).add(number);
		    	}
		    	count.lowerCount += 1;
		    	if ( number < upperLimit ) {
		    		count.upperCount += 1;
		    	}
		    	number += 1;		    	
		    }		
		
			for ( Category category : Category.values() ) {
				System.out.println("First " + tinyLimit + " " + category + " numbers:");
				for ( int i = 0; i < tinyLimit; i++ ) {
					System.out.print(String.format("%4d%s", lists.get(category).get(i), (i % 10 == 9 ? "\n" : " ")));
				}
			    System.out.println();		
			    System.out.println(lowerLimit + "th " + category + " number: " + lists.get(category).get(tinyLimit));
			    System.out.println();
			}
			
		    System.out.println("For natural numbers less than " + upperLimit + ", the breakdown is as follows:");		
		    System.out.println("    Wasteful numbers    : " + counts.get(Category.Wasteful).upperCount);
		    System.out.println("    Equidigital numbers : " + counts.get(Category.Equidigital).upperCount);
		    System.out.println("    Frugal numbers      : " + counts.get(Category.Frugal).upperCount);
		    System.out.println();	
		}
	}	
	
	private enum Category { Wasteful, Equidigital, Frugal }
	
	/**
	 * Factorise the numbers from 1 (inclusive) to limit (exclusive)
	 */
	private static void createFactors(int limit) {
		factors = IntStream.rangeClosed(0, limit).boxed()
			.map( integer -> new HashMap<Integer, Integer>() ).collect(Collectors.toList());
		factors.get(1).put(1, 1);
		
		for ( int n = 1; n < limit; n++ ) {
			if ( factors.get(n).isEmpty() ) {
				long nCopy = n;
				while ( nCopy < limit ) {
					for ( long i = nCopy; i < limit; i += nCopy ) {
						factors.get((int) i).merge(n, 1, Integer::sum);
					}
					nCopy *= n;
				}
			}
		}
	}
	
	/**
	 * Return the number of digits in the given number written in the given base
	 */
	private static int digitCount(int number, int base) {
		int result = 0;
		while ( number != 0 ) {
		    result += 1;
		    number /= base;
		}
		return result;
	}
	
	/**
	 * Return the total number of digits used in the prime factorisation
	 * of the given number written in the given base
	 */
	private static int factorCount(int number, int base) {
		int result = 0;
		for ( Map.Entry<Integer, Integer> entry : factors.get(number).entrySet() ) {
			result += digitCount(entry.getKey(), base);
			if ( entry.getValue() > 1 ) {
				result += digitCount(entry.getValue(), base);
			}
		}
		return result;
	}
	
	/**
	 * Return the category of the given number written in the given base
	 */
	private static Category category(int number, int base) {
		final int digitCount = digitCount(number, base);
		final int factorCount = factorCount(number, base);
		return ( digitCount < factorCount ) ? Category.Wasteful :
			   ( digitCount > factorCount ) ? Category.Frugal : Category.Equidigital;	
	}
	
	private static class Count {
		
		public Count(int aLowerCount, int aUpperCount) {
			lowerCount = aLowerCount; upperCount = aUpperCount;
		}
		
		private int lowerCount, upperCount;
		
	}
	
	private static List<Map<Integer, Integer>> factors;

}
