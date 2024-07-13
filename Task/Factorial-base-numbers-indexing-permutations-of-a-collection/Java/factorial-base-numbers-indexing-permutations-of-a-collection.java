import java.util.ArrayList;
import java.util.Collections;
import java.util.List;
import java.util.concurrent.ThreadLocalRandom;
import java.util.stream.Collectors;

public final class FactorialBaseNumbersIndexingPermutations {

	public static void main(String[] args) {
		// Part 1
		List<Integer> elements = convertToListInteger("0.1.2.3");
		List<Integer> factoradic = convertToListInteger("0.0.0");
		for ( int i = 0; i < factorial(4); i++ ) {	
			List<Integer> rotated = permutation(elements, factoradic);
			System.out.println(toString(factoradic, ".") + " --> " + toString(rotated, " "));
			increment(factoradic);
		}
		System.out.println();
		
		// Part 2		
		System.out.println("Generating the permutations of 11 digits:");
		final int limit = factorial(11);
		elements = convertToListInteger("0.1.2.3.4.5.6.7.8.9.10");
		factoradic = convertToListInteger("0.0.0.0.0.0.0.0.0.0");
		for ( int i = 0; i < limit; i++ ) {	
			List<Integer> rotated = permutation(elements, factoradic);
			if ( i < 3 || i > limit - 4 ) {
				System.out.println(toString(factoradic, ".") + " --> " + toString(rotated, " "));
			} else if ( i == 3 ) {
				System.out.println(" [ ... ] ");
			}
			increment(factoradic);
		}		
		System.out.println("Number of permutations is 11! = " + limit + System.lineSeparator());
		
		// Part 3.
		List<String> codes = List.of(
		    "39.49.7.47.29.30.2.12.10.3.29.37.33.17.12.31.29.34.17.25.2.4.25.4.1.14"
		    	  + ".20.6.21.18.1.1.1.4.0.5.15.12.4.3.10.10.9.1.6.5.5.3.0.0.0",
		    "51.48.16.22.3.0.19.34.29.1.36.30.12.32.12.29.30.26.14.21.8.12.1.3.10.4"
		    	  + ".7.17.6.21.8.12.15.15.13.15.7.3.12.11.9.5.5.6.6.3.4.0.3.2.1" );
		    		
		List<String> cards = List.of( "A♠", "K♠", "Q♠", "J♠", "10♠", "9♠", "8♠", "7♠", "6♠", "5♠", "4♠", "3♠", "2♠",
		           					  "A♥", "K♥", "Q♥", "J♥", "10♥", "9♥", "8♥", "7♥", "6♥", "5♥", "4♥", "3♥", "2♥",
		           					  "A♦", "K♦", "Q♦", "J♦", "10♦", "9♦", "8♦", "7♦", "6♦", "5♦", "4♦", "3♦", "2♦",
		           					  "A♣", "K♣", "Q♣", "J♣", "10♣", "9♣", "8♣", "7♣", "6♣", "5♣", "4♣", "3♣", "2♣" );
		
		System.out.println("Original deck of cards:");
		System.out.println(toString(cards, " ") + System.lineSeparator());
		System.out.println("Task shuffles:");				
		for ( String code : codes ) {
			System.out.println(code + " --> ");
			factoradic = convertToListInteger(code);
			System.out.println(toString(permutation(cards, factoradic), " "));
			System.out.println();
		}
		
		System.out.println("Random shuffle:");
		ThreadLocalRandom random = ThreadLocalRandom.current();
		factoradic.clear();
		for ( int i = 0; i < cards.size() - 1; i++ ) {
			factoradic.add(random.nextInt(cards.size() - i));
		}
		System.out.println(toString(factoradic, ".") + " --> ");
		System.out.println(toString(permutation(cards, factoradic), " "));
	}	
	
	private static <T> List<T> permutation(List<T> elements, List<Integer> factoradic) {
		List<T> copy = new ArrayList<T>(elements);
		int m = 0;
		for ( int g : factoradic ) {		
			Collections.rotate(copy.subList(m, m + g + 1), 1);
			m += 1;
		}
		return copy;
	}
	
	private static void increment(List<Integer> factoradic) {
		int index = factoradic.size() - 1;
		while ( index >= 0 && factoradic.get(index) == factoradic.size() - index ) {
			factoradic.set(index, 0);
			index -= 1;
		}
		if ( index >= 0 ) {
			factoradic.set(index, factoradic.get(index) + 1);
		}
	}	
	
	private static List<Integer> convertToListInteger(String text) {
		List<Integer> result = new ArrayList<Integer>();
		String[] numbers = text.split("\\.");
		for ( String number : numbers ) {
			result.add(Integer.valueOf(number));
		}
		return result;
	}
	
	private static int factorial(int n) {
		int factorial = 1;
		for ( int i = 2; i <= n; i++ ) {
			factorial *= i;
		}
		return factorial;
	}
	
	private static <T> String toString(List<T> factoradic, String delimiter) {
		return factoradic.stream().map(String::valueOf).collect(Collectors.joining(delimiter));
	}
			
}
