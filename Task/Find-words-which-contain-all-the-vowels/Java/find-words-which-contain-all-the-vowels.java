import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Path;

public final class FindWordsWhichContainAllTheVowels {

	public static void main(String[] args) throws IOException {	
		Files.lines(Path.of("unixdict.txt")).filter( s -> s.length() > 10 &&
				"aeiou".chars().allMatch( v -> s.chars().filter( ch -> ch == v ).count() == 1 ) )
			.forEach(System.out::println);
	}

}
