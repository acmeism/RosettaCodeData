import java.io.IOException;
import java.nio.file.*;

public class WalkTree {
	public static void main(String[] args) throws IOException {
		Path start = FileSystems.getDefault().getPath("/path/to/file");
		Files.walk(start)
		     .filter( path -> path.toFile().isFile())
		     .filter( path -> path.toString().endsWith(".mp3"))
		     .forEach( System.out::println );
	}
}
