import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Path;

public final class ReadSpecificLineFromFile {

	public static void main(String[] aArgs) throws IOException {
		String fileName = "input.txt";
		Path filePath = Path.of(fileName);
		
		String seventhLine = Files.lines(filePath).skip(6).findFirst().orElse(ERROR_TOO_FEW_LINES);
		
		String messageToUser = seventhLine.isBlank() ? ERROR_EMPTY_LINE : seventhLine;
		System.out.println(messageToUser);		
	}	
	
	private static final String ERROR_TOO_FEW_LINES = "File has fewer than 7 lines";
	private static final String ERROR_EMPTY_LINE = "Line 7 is empty";

}
