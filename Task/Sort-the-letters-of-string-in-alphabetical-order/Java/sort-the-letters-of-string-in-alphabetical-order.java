import java.util.List;
import java.util.function.BiConsumer;
import java.util.function.Function;
import java.util.stream.IntStream;

public final class SortTheLettersOfStringInAlphabeticalOrder {

	public static void main(String[] args) {		
		Function<String, String> bubbleSort = ( text -> {
			char[] chars = text.toCharArray();
		    BiConsumer<char[], Integer> swapValueIf = (array, i) -> {
		        if ( array[i] > array[i + 1] ) {
		            final char temp = array[i];
		            chars[i] = array[i + 1];
		            chars[i + 1] = temp;
		        }
		    };

		    IntStream.range(0, chars.length - 1)
		    	.forEach( i -> IntStream.range(0, chars.length - 1)
		            .forEach( j -> swapValueIf.accept(chars, j) ) );
		
		    return new String(chars);
		} );
		
		List<String> tests = List.of( "Now is the time for all good men to come to the aid of the party.",
				                      "The quick brown dog jumped over the lazy fox." );
		
		tests.forEach( test -> {
			System.out.println(test + " =>");
			System.out.println(bubbleSort.apply(test));
		} );
	}
	
}
