import module java.base;

public final class FixedLengthRecords {

	public static void main() throws IOException {
		try ( FileChannel reader = FileChannel.open(Path.of("./infile.dat"), StandardOpenOption.READ);
			FileChannel writer = FileChannel.open(Path.of("./outfile.dat"), StandardOpenOption.CREATE,
																			StandardOpenOption.WRITE) ) {
		
			ByteBuffer buffer = ByteBuffer.allocate(BUFFER_SIZE);
			
			while ( reader.read(buffer) != END_OF_FILE ) {
				for ( int i = 0, j = BUFFER_SIZE - 1; i < j; j--, i++ ) {
				    final byte temp = buffer.get(i);
				    buffer.put(i, buffer.get(j));
				    buffer.put(j, temp);
				}
				
				buffer.flip();
				writer.write(buffer);
				buffer.flip();
			}
		}
	}
	
	private static final int BUFFER_SIZE = 80;
	private static final int END_OF_FILE = -1;

}
