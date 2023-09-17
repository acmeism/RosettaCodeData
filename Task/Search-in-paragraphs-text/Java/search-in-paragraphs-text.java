import java.io.IOException;
import java.nio.charset.StandardCharsets;
import java.nio.file.Files;
import java.nio.file.Path;

public final class SearchInParagraphsText {

	public static void main(String[] args) throws IOException {	
		Path filePath = Path.of("./Traceback.txt");
		String fileContents = Files.readString(filePath, StandardCharsets.UTF_8);
	    String[] paragraphs = fileContents.split(PARAGRAPH_SEPARATOR);
	    for ( String paragraph : paragraphs ) {
	    	if ( paragraph.contains("SystemError") ) {
	    		int index = paragraph.indexOf("Traceback (most recent call last):");
	    		if ( index >= 0 ) {
	            	System.out.println(paragraph.substring(index));
	            	System.out.println("----------------");
	            }
    		}
	    }
	}
	
	private static final String PARAGRAPH_SEPARATOR = "\r\n\r\n";

}
