import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Path;

public final class CreateAFile {

	public static void main(String[] args) throws IOException {
		Files.createFile(Path.of("output.txt"));		
		Files.createDirectory(Path.of("docs"));
		
		Files.createFile(Path.of("/output.txt"));
		Files.createDirectory(Path.of("/docs"));
	}

}
