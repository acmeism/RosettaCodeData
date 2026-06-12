import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Path;
import java.util.List;

public final class ChangeELettersToIInWords {

	public static void main(String[] args) throws IOException {
		List<String> words = Files.lines(Path.of("unixdict.txt")).filter( word -> word.length() > 5 ).toList();
		
		words.forEach( word -> {
			if ( word.contains("e") ) {
				String alteredWord = word.replace("e", "i");
				if ( words.contains(alteredWord) ) {
					System.out.println(word + " => " + alteredWord);
				}
			}
		} );
	}

}
