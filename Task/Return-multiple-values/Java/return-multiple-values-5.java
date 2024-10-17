import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Path;
import java.util.List;
import java.util.Set;
import java.util.stream.Collectors;

/**
 * Java methods can only return a single value which can include a list, map or array.
 * As noted by the earlier post it is not desirable to use the Object type
 * because it may need to be cast into another more specific type.
 *
 * In version 16, Java introduced the 'record' class which can act as a tuple containing any number of fields
 * of a standard Java type. This has almost completely eliminated the above problem.
 *
 * Some examples of records are:
 *       Pair(String text1, String text2),
 *       Circle(Point centre, double radius),
 *       VirtualMachineInfo(int dataSize, List<String> vmStrings, List<Byte> codes),
 *       Data(String text, int[] arguments, Iterator iterator).
 *
 * The example program below requires the file 'unixdict.txt', which can be downloaded from:
 * http://wiki.puzzlers.org/pub/wordlists/unixdict.txt
 */
public class ReturnMultipleValues {
	
	public static void main(String[] args) throws IOException {
		Set<Character> hexDigits = Set.of( 'a', 'b', 'c', 'd', 'e', 'f' );
		
		List<Item> items = Files.lines(Path.of("unixdict.txt"))
								.filter( word -> word.length() >= 4 )
								.filter( word -> word.chars()
                                    .allMatch( ch -> hexDigits.contains((char) ch) ) )			
								.map( word -> { final int value = Integer.parseInt(word, 16);
												return new Item(word, value, digitalRoot(value));
											  } )
								.collect(Collectors.toList());
		
		items.forEach(System.out::println);
	}

	private static int digitalRoot(int aNumber) {
	    int result = 0;
    	while ( aNumber > 0 ) {
    		result += aNumber % 10;
    		aNumber /= 10;
    	}
	    return ( result <= 9 ) ? result : digitalRoot(result);		
	}
	
	private static record Item(String word, int number, int digitalRoot) {
		
		public String toString() {
			return "[" + word + ", " + number + ", " + digitalRoot + "]";
		}
		
	}

}
