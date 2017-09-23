package rosetta;

import java.io.IOException;
import java.io.PrintStream;
import java.nio.file.DirectoryStream;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;

public class UnixLS {

	public static void main(String[] args) throws IOException {
		UnixLS ls = new UnixLS();
		ls.list(System.out);
	}

	private void list(PrintStream out) throws IOException {
		try (DirectoryStream<Path> stream = Files.newDirectoryStream(Paths.get("."))) {
			stream.forEach((path) -> out.println(path.getFileName()));
		}
	}
}
