import java.util.List;
import java.nio.charset.Charset;
import java.nio.file.*;

public class ReadAll {
	public static List<String> readAllLines(String filesname){
		Path file = Paths.get(filename);
		return Files.readAllLines(file, Charset.defaultCharset());
	}
	
	public static byte[] readAllBytes(String filename){
		Path file = Paths.get(filename);
		return Files.readAllBytes(file);
	}
}
