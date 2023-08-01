import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.net.URI;
import java.util.ArrayList;
import java.util.List;
import java.util.function.Predicate;

public final class WordWheelExtended {

	public static void main(String[] args) throws IOException {
		String wordWheel = "N  D  E"
				         + "O  K  G"
				         + "E  L  W";
		
		String url = "http://wiki.puzzlers.org/pub/wordlists/unixdict.txt";		
		InputStream stream = URI.create(url).toURL().openStream();
		BufferedReader reader = new BufferedReader( new InputStreamReader(stream) );
		List<String> words = reader.lines().toList();	
		reader.close();
		
		String allLetters = wordWheel.toLowerCase().replace(" ", "");		
		String middleLetter = allLetters.substring(4, 5);
		
		Predicate<String> firstFilter = word -> word.contains(middleLetter) && 2 < word.length() && word.length() < 10;
		Predicate<String> secondFilter = word -> word.chars().allMatch( ch -> allLetters.indexOf(ch) >= 0 );
		Predicate<String> correctWords = firstFilter.and(secondFilter);
		
		words.stream().filter(correctWords).forEach(System.out::println);
		
		int maxWordsFound = 0;
		List<String> bestWords9 = new ArrayList<String>();
		List<Character> bestCentralLetters = new ArrayList<Character>();
		List<String> words9 = words.stream().filter( word -> word.length() == 9 ).toList();

		for ( String word9 : words9 ) {			
			List<Character> distinctLetters = word9.chars().mapToObj( i -> (char) i ).distinct().toList();			
			for ( char letter : distinctLetters ) {
				int wordsFound = 0;
				for ( String word : words ) {
					if ( word.length() >= 3 && word.indexOf(letter) >= 0 ) {
		                List<Character> letters = new ArrayList<Character>(distinctLetters);
		                boolean validWord = true;
		                for ( char ch : word.toCharArray() ) {
		                    final int index = letters.indexOf(ch);
		                    if ( index == -1 ) {
		                        validWord = false;
		                        break;
		                    }
		                    letters.remove(index);
		                }
		                if ( validWord ) {
		                	wordsFound += 1;
		                }
		            }
				}
				
				if ( wordsFound > maxWordsFound ) {
		            maxWordsFound = wordsFound;
		            bestWords9.clear();
		            bestWords9.add(word9);
		            bestCentralLetters.clear();
		            bestCentralLetters.add(letter);
		        } else if ( wordsFound == maxWordsFound ) {
		            bestWords9.add(word9);
		            bestCentralLetters.add(letter);
		        }				
			}
		}
		
		System.out.println(System.lineSeparator() + "Most words found = " + maxWordsFound);
		System.out.println("The nine letter words producing this total are:");
		for ( int i = 0; i < bestWords9.size(); i++ ) {
		    System.out.println(bestWords9.get(i) + " with central letter '" + bestCentralLetters.get(i) + "'");
		}		
	}	

}
