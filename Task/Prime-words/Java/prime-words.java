import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Path;
import java.util.List;

public final class PrimeWords {

	public static void main(String[] args) throws IOException {
		List<Integer> primeLetterValues = List.of( 67, 71, 73, 79, 83, 89, 97, 101, 103, 107, 109, 113 );
				
		Files.lines(Path.of("./unixdict.txt")).filter( w -> w.chars().allMatch( i -> primeLetterValues.contains(i) ) )
			 .forEach(System.out::println);
	}

}
