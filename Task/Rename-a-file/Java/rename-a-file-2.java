import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Path;
import java.util.List;

public final class RenameAFile {

	public static void main(String[] args) throws IOException {
		List<Path> source =	List.of( Path.of("input.txt"),  Path.of("docs"),
                                     Path.of("C://input.txt") , Path.of("C://docs") );
	    List<Path> target = List.of( Path.of("output.txt"), Path.of("mydocs"),
                                     Path.of("C://output.txt"), Path.of("C://mydocs") );
	
	    for ( int i = 0; i < source.size(); i++ ) {
	    	Files.move(source.get(i), target.get(i));
	    	System.out.println( Files.exists(target.get(i)) ?
	    		"File '" + source.get(i) + "' successfully renamed to '" + target.get(i) + "'":
	    		"Unable to rename file: " + source.get(i));
	    }  	
	}

}
