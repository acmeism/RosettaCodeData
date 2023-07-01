import java.io.IOException;
import java.nio.file.Path;
import java.util.AbstractSet;
import java.util.Comparator;
import java.util.HashMap;
import java.util.Map;
import java.util.Scanner;
import java.util.TreeSet;

public final class IsogramsAndHeterograms {

	public static void main(String[] aArgs) throws IOException {
		AbstractSet<IsogramPair> isograms = new TreeSet<IsogramPair>(comparatorIsogram);	
	
		Scanner scanner = new Scanner(Path.of("unixdict.txt"));
	    while ( scanner.hasNext() ) {
	    	String word = scanner.next().toLowerCase();
	    	final int value = isogramValue(word);
	    	if ( value > 1 || ( word.length() > 10 && value == 1 ) ) {
	    		isograms.add( new IsogramPair(word, value) );
	    	}  	
	    }
	    scanner.close();
	
	    System.out.println("n-isograms with n > 1:");
	    isograms.stream().filter( pair -> pair.aValue > 1 ).map( pair -> pair.aWord ).forEach(System.out::println);
	    System.out.println(System.lineSeparator() + "Heterograms with more than 10 letters:");
	    isograms.stream().filter( pair -> pair.aValue == 1 ).map( pair -> pair.aWord ).forEach(System.out::println);	
	}
	
	private static int isogramValue(String aWord) {
	    Map<Character, Integer> charCounts = new HashMap<Character, Integer>();
	    for ( char ch : aWord.toCharArray() ) {
	    	charCounts.merge(ch, 1, Integer::sum);
	    }
	
	    final int count = charCounts.get(aWord.charAt(0));
	    final boolean identical = charCounts.values().stream().allMatch( i -> i == count );
	    return identical ? count : 0;
	}
	
	private static Comparator<IsogramPair> comparatorIsogram =
		Comparator.comparing(IsogramPair::aValue, Comparator.reverseOrder())
		.thenComparing(IsogramPair::getWordLength, Comparator.reverseOrder())
		.thenComparing(IsogramPair::aWord, Comparator.naturalOrder());
	
	private record IsogramPair(String aWord, int aValue) {
		
		private int getWordLength() {
			return aWord.length();
		}
		
	};

}
