import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Path;

public final class FindWordsWhoseFirstAndLastThreeLettersAreEqual {

	public static void main(String[] args) throws IOException {
		Files.lines(Path.of("./unixdict.txt"))
			 .filter( w -> w.length() > 5 && w.substring(0, 3).equals(w.substring(w.length() - 3)))			
			 .forEach( w -> System.out.print(w + " ") );
	}

}
