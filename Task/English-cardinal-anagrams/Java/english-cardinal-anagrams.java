import java.util.ArrayList;
import java.util.Collection;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;
import java.util.stream.Stream;

public final class EnglishCardinalAnagrams {

	public static void main(String[] args) {
		for ( int limit : List.of( 1_000, 10_000 ) ) {
		    Map<List<Character>, List<Integer>> anagrams = new HashMap<List<Character>, List<Integer>>();
		    for ( int i = 0; i < limit; i++ ) {
		    	String name = NumberToWordsConverter.convert(i).toLowerCase();
		    	List<Character> chars = name.chars().mapToObj( ch -> (char) ch ).sorted().toList();
		    	anagrams.computeIfAbsent(chars, k -> new ArrayList<Integer>() ).add(i);
		    }
		
		    if ( limit == 1_000 ) {
		    	List<Integer> allAnagrams = anagrams.values().stream().filter( list -> list.size() > 1 )
		    		.flatMap(Collection::stream).sorted().toList();		    	
		    	System.out.println("First 30 English cardinal anagrams:");
		    	for ( int i = 0; i < 30; i++ ) {
		    		System.out.print(String.format("%3d%s", allAnagrams.get(i),
		    			( i % 10 == 9 ) ? "\n" : " " ));
		    	}
		        System.out.println();
		    }		
		
		    final long count = anagrams.values().stream().filter( list -> list.size() > 1  ).count();
		    System.out.println("Count of English cardinal anagrams up to 1000: " + count);
		    System.out.println();
		
		    int max = 0;
    	    List<List<Integer>> largest = new ArrayList<List<Integer>>();
    	    for ( List<Integer> list : anagrams.values() ) {
    	        if ( list.size() > max ) {
    	            max = list.size();
    	            largest = Stream.of( list ).limit(1).collect(Collectors.toList());
    	        } else if ( list.size() == max ) {
    	            largest.addLast(list);
    	        }
    	    }
    	    System.out.println("Largest group(s) of English cardinal anagrams up to " + limit + ": ");    	
    	    largest.sort( (list1, list2) -> list1.getFirst().compareTo(list2.getFirst()));
    	    largest.forEach(System.out::println);
    	    System.out.println();
		}
	}
	
	private static final class NumberToWordsConverter { // Valid for positive integers ≤ 999_999_999	

		public static String convert(int n) {
			if ( n < 20 ) {
				return units[n];
			}
			if ( n < 100 ) {
				return tens[n / 10] + ( ( n % 10 > 0 ) ? " " + convert(n % 10) : "" );
			}
			if ( n < 1_000 ) {
				return units[n / 100] + " Hundred" + ( ( n % 100 > 0 ) ? " and " + convert(n % 100) : "" );
			}
			if ( n < 1_000_000 ) {
				return convert(n / 1_000) + " Thousand"
                    + ( ( n % 1_000 > 0 ) ? " " + convert(n % 1_000) : "" );
			}
			return convert(n / 1_000_000) + " Million"
				+ ( ( n % 1_000_000 > 0 ) ? " " + convert(n % 1_000_000) : "" );		
		}
		
		private static final String[] units = { "Zero", "One", "Two", "Three", "Four", "Five", "Six",
			"Seven", "Eight", "Nine", "Ten", "Eleven", "Twelve", "Thirteen",
			"Fourteen", "Fifteen", "Sixteen", "Seventeen", "Eighteen", "Nineteen" };
		
		private static final String[] tens =
			{ "", "", "Twenty", "Thirty", "Forty", "Fifty", "Sixty", "Seventy", "Eighty", "Ninety" };
		
	}
	
}
