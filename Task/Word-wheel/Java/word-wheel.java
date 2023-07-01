import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.net.URI;
import java.util.function.Predicate;

public final class WordWheel {

	public static void main(String[] args) throws IOException {
		String wordWheel = "N  D  E"
				         + "O  K  G"
				         + "E  L  W";		
		
		String allLetters = wordWheel.toLowerCase().replace(SPACE_CHARACTER, EMPTY_STRING);		
		String middleLetter = allLetters.substring(4, 5);
		
		Predicate<String> correctWords = word -> {
			if ( ! word.contains(middleLetter) || 3 > word.length() || word.length() > 9 ) {
				return false;
			}
						
			for ( String letter : allLetters.split(EMPTY_STRING) ) {
				word = word.replaceFirst(letter, EMPTY_STRING);
			}
			
			return word.isEmpty();
		};
		
		String url = "http://wiki.puzzlers.org/pub/wordlists/unixdict.txt";		
		InputStream stream = URI.create(url).toURL().openStream();
		BufferedReader reader = new BufferedReader( new InputStreamReader(stream) );
		reader.lines().filter(correctWords).forEach(System.out::println);
	}	
	
	private static final String EMPTY_STRING = "";
	private static final String SPACE_CHARACTER = " ";

}
