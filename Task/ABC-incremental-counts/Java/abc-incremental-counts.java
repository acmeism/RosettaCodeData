import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Path;
import java.util.Arrays;
import java.util.List;
import java.util.stream.Collectors;

public final class ABCIncrementalCounts {

	public static void main(String[] args) throws IOException {
		record Test(String fileName, String letters, int minCount) {}
		
		List<Test> tests = List.of(	new Test("./unixdict.txt", "abc", 1), new Test("./unixdict.txt", "cio", 2),
			new Test("./words_alpha.txt", "the", 2), new Test("./words_alpha.txt", "cio", 3) );
		
		for ( Test test : tests ) {
			System.out.println(System.lineSeparator() + "Filtering the file '" + test.fileName.substring(2)
				+ "' for the letters '" + test.letters + "' with a minimum occurrence of " + test.minCount + ":");
			
			Files.lines(Path.of(test.fileName))
				.filter( w -> incremental(w, test.letters, test.minCount) )
				.forEach(System.out::println);
		}
	}
	
	private static boolean incremental(String word, String letters, int min) {
		List<Integer> counts = Arrays.stream(word.split(""))
			.filter( s -> letters.contains(s) )
			.collect(Collectors.toMap(String::toLowerCase, v -> 1, Integer::sum))
			.values().stream().sorted().toList();
		
		return counts.size() == letters.length() &&
			   counts.get(0) >= min && counts.get(1) == counts.get(0) + 1 && counts.get(2) == counts.get(0) + 2;
	}
	
}
