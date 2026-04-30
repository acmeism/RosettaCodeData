import module java.base;

public final class FixedLengthRecordsBonusRound {

	public static void main() throws IOException {
		// Create and display the 'forth.txt' file obtained from the 'sample.txt' file used in the standard task
		textToBlock("./sample.txt", "./forth.blk");
		blockToText("./forth.blk", "./forth.txt");		
		Files.lines(Path.of("./forth.txt")).forEach(IO::println);
		
		// Check the result of a round trip conversion: text => block => text
		textToBlock("./forth.txt", "./forth_2.blk");
		blockToText("./forth_2.blk", "./forth_2.txt");	
		final boolean mismatch = ( Files.mismatch(Path.of("./forth.txt"), Path.of("./forth_2.txt")) > 0 );
		IO.println("Files matched? " + ! mismatch);
	}
	
	// Read the lines of a text file and write them as 64 byte records
	private static void textToBlock(String inputFilePath, String outputFilePath) {		
		try ( BufferedReader reader = Files.newBufferedReader(Path.of(inputFilePath));
			BufferedWriter writer = Files.newBufferedWriter(Path.of(outputFilePath)) ) {
			
			int lineCount = 0;
		    String line;
		    while ( ( line = reader.readLine() ) != null ) {
		    	if ( line.length() > LINE_SIZE ) {
				   	line = line.substring(0, LINE_SIZE);
				} else if ( line.length() < LINE_SIZE ) {
				   	line += " ".repeat(LINE_SIZE - line.length());
				}
				
		    	writer.write(line);
		    	lineCount += 1;
		    }
		
		    // Complete the block with empty lines
		    final int emptyLineCount = ( LINE_COUNT - lineCount % LINE_COUNT ) % LINE_COUNT;
		    for ( int i = 0; i < emptyLineCount; i++ ) {
		    	writer.write(EMPTY_LINE);
		    }	
		} catch (IOException ioe) {
		    ioe.printStackTrace();
		}
	}
	
	// Read 64 bytes records and write them as lines with trailing spaces removed
	private static void blockToText(String inputFilePath, String outputFilePath) {
		try ( FileChannel reader = FileChannel.open(Path.of(inputFilePath), StandardOpenOption.READ);
			BufferedWriter writer = Files.newBufferedWriter(Path.of(outputFilePath)) ) {
			
			ByteBuffer buffer = ByteBuffer.allocate(LINE_SIZE);
			
			while ( reader.read(buffer) != END_OF_FILE ) {
		    	writer.write( new String(buffer.array()).stripTrailing() + System.lineSeparator() );
		    	buffer.flip();
		    }			
		} catch (IOException ioe) {
			ioe.printStackTrace();
		}
	}
	
	private static final int LINE_SIZE = 64;
	private static final int LINE_COUNT = 16;	
	private static final int END_OF_FILE = -1;
	private static final String EMPTY_LINE = " ".repeat(LINE_SIZE);

}
