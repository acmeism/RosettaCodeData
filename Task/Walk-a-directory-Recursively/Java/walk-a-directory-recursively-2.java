import java.io.IOException;
import java.nio.file.*;
import java.nio.file.attribute.BasicFileAttributes;

public class WalkTree {
	public static void main(String[] args) throws IOException {
		Path start = FileSystems.getDefault().getPath("/path/to/file");
		Files.walkFileTree(start, new SimpleFileVisitor<Path>() {
			@Override
			public FileVisitResult visitFile(Path file,
					BasicFileAttributes attrs) throws IOException {
				if (file.toString().endsWith(".mp3")) {
					System.out.println(file);
				}
				return FileVisitResult.CONTINUE;
			}
		});
	}
}
