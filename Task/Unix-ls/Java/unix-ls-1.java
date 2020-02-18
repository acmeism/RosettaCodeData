package rosetta;

import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Path;

public class UnixLS {

	public static void main(String[] args) throws IOException {
		Files.list(Path.of("")).sorted().forEach(System.out::println);
	}
}
