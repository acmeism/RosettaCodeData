import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Path;
import java.util.ArrayList;
import java.util.Comparator;
import java.util.List;
import java.util.Map;
import java.util.TreeMap;

public final class FindWordsWhichContainTheMostConsonants {

	public static void main(String[] args) throws IOException {	
		Map<Long, List<String>> wordMap = new TreeMap<Long, List<String>>(Comparator.reverseOrder());
		
		Files.lines(Path.of("unixdict.txt")).forEach( word -> {
			long count = 0;
			if ( word.length() > 10 && ( count = uniqueConsonantCount(word) ) > 0 ) {
				wordMap.computeIfAbsent(count, v -> new ArrayList<String>()).addLast(word);
			}			
		} );
		
		wordMap.forEach( (k, v) -> {
			System.out.println("Word count with " + k + " unique consonants: " + v.size());
			for ( int i = 0; i< v.size(); i++ ) {
				System.out.print(String.format("%-18s%s", v.get(i), ( i % 6 == 5 ? "\n" : "  " )));
			}
			System.out.println(System.lineSeparator());			
		} );
	}
	
	private static long uniqueConsonantCount(String word) {
		List<Character> consonants = word.chars()
			.mapToObj( i -> (char) i )
			.map( ch -> Character.toLowerCase(ch) )
			.filter( ch -> ch >= 'a' && ch <= 'z' && ! VOWELS.contains(ch) ).toList();
		
		final long distinctConsonants = consonants.stream().distinct().count();		
		return ( consonants.size() == distinctConsonants ) ? distinctConsonants : 0;
	}
	
	private static final List<Character> VOWELS = List.of( 'a', 'e', 'i', 'o', 'u' );

}
