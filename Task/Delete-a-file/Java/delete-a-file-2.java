import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Path;

public final class DeleteAFile {

	public static void main(String[] args) throws IOException {
		Files.delete(Path.of("output.txt"));		
		Files.delete(Path.of("docs"));
		
		Files.delete(Path.of("/output.txt"));
		Files.delete(Path.of("/docs"));
	}

}
