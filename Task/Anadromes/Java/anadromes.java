import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Path;
import java.util.Collections;
import java.util.List;

public class Anadromes {

	public static void main(String[] args) throws IOException {
		List<String> words = Files.lines(Path.of("words.txt")).filter( word -> word.length() > 6 ).sorted().toList();
		
		System.out.println("The anadrome pairs with more than 6 letters are:");
		for ( String word : words ) {
		    String wordReversed = new StringBuilder(word).reverse().toString();
		    if ( wordReversed.compareTo(word) > 0 && Collections.binarySearch(words, wordReversed) > 0 ) {
		    	System.out.println(word + " <--> " + wordReversed);
		    }
		}
	}

}
