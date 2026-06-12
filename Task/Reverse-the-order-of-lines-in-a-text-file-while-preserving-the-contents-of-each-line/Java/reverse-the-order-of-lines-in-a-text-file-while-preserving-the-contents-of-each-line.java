import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.StandardOpenOption;
import java.util.Collections;
import java.util.List;
import java.util.stream.Collectors;

public final class ReverseTheOrderOfLinesInATextFileWhilePreservingTheContentsOfEachLine {

	public static void main(String[] args) throws IOException {
		List<String> lines = Files.lines(Path.of("./DiplomacyQuote.txt")).collect(Collectors.toList());
		Collections.reverse(lines);
		
		String contents = lines.stream().collect(Collectors.joining());
		Files.write(Path.of("./DiplomacyQuote.txt"), lines, StandardOpenOption.WRITE);
			
		// Display the new contents of the 'DiplomacyQuote.txt' file		
		Files.lines(Path.of("./DiplomacyQuote.txt")).forEach(System.out::println);		
	}

}
