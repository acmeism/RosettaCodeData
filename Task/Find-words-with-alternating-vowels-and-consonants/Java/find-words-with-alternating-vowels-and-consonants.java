import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Path;
import java.util.List;

public final class FindWordsWithAlternatingVowelsAndConsonants {

	public static void main(String[] args) throws IOException {
		Files.lines(Path.of("./unixdict.txt"))
			.filter( w -> w.length() > 9 && alternatingVowelsAndConsonants(w) )			
			.forEach( w -> System.out.print(w + " ") );
	}
	
	private static boolean alternatingVowelsAndConsonants(String text) {
	    for ( int i = 1; i < text.length(); i++ ) {
	        if ( VOWELS.contains(text.charAt(i)) == VOWELS.contains(text.charAt(i - 1)) ) {
	            return false;
			}
	    }
	    return true;
	}
	
	private static final List<Character> VOWELS = List.of( 'a', 'e', 'i', 'o', 'u' );

}
