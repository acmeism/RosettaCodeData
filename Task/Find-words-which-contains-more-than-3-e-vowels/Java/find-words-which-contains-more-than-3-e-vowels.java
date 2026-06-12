import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Path;
import java.util.List;

public final class FindWordsWhichContainMoreThan3EVowels {

	public static void main(String[] args) throws IOException {
		Files.lines(Path.of("unixdict.txt"))
			.filter( word -> word.chars().filter(
                i -> List.of( 'a', 'i', 'o', 'u' ).contains((char) i) ).count() == 0 )
			.filter( word -> word.chars().filter( i -> i == 'e' ).count() > 3 )	
		    .forEach(System.out::println);
	}

}
