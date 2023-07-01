import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.StandardOpenOption;

public final class WriteEntireFile {

	public static void main(String[] aArgs) throws IOException {
		String contents = "Hello World";
		String filePath = "output.txt";
		
		Files.write(Path.of(filePath), contents.getBytes(), StandardOpenOption.CREATE);
	}

}
