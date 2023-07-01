import java.io.BufferedReader;
import java.io.IOException;
import java.nio.charset.StandardCharsets;
import java.nio.file.Files;
import java.nio.file.Path;

public final class ReadFileByCharacter {
	
	public static void main(String[] aArgs) {
		Path path = Path.of("input.txt");
		
		try ( BufferedReader reader = Files.newBufferedReader(path, StandardCharsets.UTF_8) ) {
			int value;
			while ( ( value = reader.read() ) != END_OF_STREAM ) {
				System.out.println((char) value);
			}
		} catch (IOException ioe) {
			ioe.printStackTrace();
		}	
	}
	
	private static final int END_OF_STREAM = -1;

}
