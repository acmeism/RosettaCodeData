import java.io.BufferedReader;
import java.io.BufferedWriter;
import java.io.FileReader;
import java.io.FileWriter;
import java.io.IOException;
import java.nio.charset.StandardCharsets;

public final class BitwiseIO {

	public static void main(String[] args) throws IOException {
	    BitFilter bitFilter = new BitFilter("BitwiseIO.dat");
	    byte[] source = "abcde12345".getBytes(StandardCharsets.ISO_8859_1);
	
	    // For each byte in 'source', write 7 bits omitting the most significant bit
	    for ( int i = 0; i < source.length; i++ ) {
	    	bitFilter.write(source, i, 7, 1);
	    }
	    bitFilter.closeWriter();

	    // Read 7 bits and expand to a byte of 'destination' by reconstructing the most significant bit
	    byte[] destination = new byte[source.length];
	    for ( int i = 0; i < destination.length; i++ ) {
	    	bitFilter.read(destination, i, 7, 1);
	    }
	    bitFilter.closeReader();
	
	    System.out.println( new String(destination) );
	}

}

final class BitFilter {
	
	public BitFilter(String filePath) throws IOException  {
		bufferedWriter = new BufferedWriter( new FileWriter(filePath) );
		bufferedReader  = new BufferedReader( new FileReader(filePath) );
	}
	
	public void write(byte[] bytes, int startIndex, int bitCount, int bitsOmittedCount) throws IOException {
        int index = startIndex + bitsOmittedCount / 8;
        bitsOmittedCount %= 8;

        while ( bitCount > 0 || bits >= 8 ) {
            while ( bits >= 8 ) {
                bits -= 8;
                bufferedWriter.write(accumulator >>> bits);
                accumulator &= ( 1 << bits ) - 1;
            }

            while ( bits < 8 && bitCount > 0 ) {
                accumulator = ( accumulator << 1 ) |
                	( ( ( 128 >>> bitsOmittedCount ) & bytes[index] ) >>> ( 7 - bitsOmittedCount ) );
                bitCount -= 1;
                bits += 1;
                if ( ++bitsOmittedCount == 8 ) {
                	bitsOmittedCount = 0;
                	index += 1;
                }
            }
        }
    }
	
	public void read(byte[] bytes, int startIndex, int bitCount, int bitsOmittedCount) throws IOException {
        int index = startIndex + bitsOmittedCount / 8;
        bitsOmittedCount %= 8;

        while ( bitCount > 0 ) {
            while ( bits > 0 && bitCount > 0 ) {
                final int mask = 128 >>> bitsOmittedCount;
                if ( ( accumulator & ( 1 << ( bits - 1 ) ) ) > 0 ) {
                    bytes[index] = (byte) ( bytes[index] | mask );
                } else {
                    bytes[index] = (byte) ( bytes[index] & ( ~mask & 0xff ) );
                }

                bitCount -= 1;
                bits -= 1;
                if ( ++bitsOmittedCount >= 8 ) {
                	bitsOmittedCount = 0;
                	index += 1;
                }
            }

            if ( bitCount > 0 ) {
            	accumulator = ( accumulator << 8 ) | bufferedReader.read();
            	bits += 8;
            }
        }
    }
	
	public void closeWriter() throws IOException {
        if ( bits != 0 ) {
        	accumulator <<= 8 - bits;
            bufferedWriter.write(accumulator);
        }

        bufferedWriter.close();
        accumulator = 0;
        bits = 0;
    }

    public void closeReader() throws IOException {
        bufferedReader.close();
        accumulator = 0;
        bits = 0;
    }	

	private int accumulator, bits;
	private BufferedWriter bufferedWriter;
	private BufferedReader bufferedReader;
	
}
