import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Path;
import java.util.List;

public final class OrderedWords {

	public static void main(String[] aArgs) throws IOException {
		List<String> ordered = Files.lines(Path.of("unixdict.txt"))
				                    .filter( word -> isOrdered(word) ).toList();
	    	
	    final int maxLength = ordered.stream().map( word -> word.length() ).max(Integer::compare).get();
	    ordered.stream().filter( word -> word.length() == maxLength ).forEach(System.out::println);	
	}
	
	private static boolean isOrdered(String aWord) {
		return aWord.chars()
				    .mapToObj( i -> (char) i )
				    .sorted()
				    .map(String::valueOf)
				    .reduce("", String::concat)
				    .equals(aWord);
	}

}
