import java.nio.charset.StandardCharsets;
import java.util.Arrays;

public final class SHA1Task {

	public static void main(String[] args) {
		System.out.println(SHA1.messageDigest("Rosetta Code"));
	}

}

final class SHA1 {
	
	public static String messageDigest(String message) {
		int[] state = { 0x67452301, 0xefcdab89, 0x98badcfe, 0x10325476, 0xc3d2e1f0 };
		
		byte[] bytes = addPadding(message);	
		for ( int i = 0; i < bytes.length / BLOCK_LENGTH; i++ ) {			
			int[] values = new int[80];
			for ( int j = 0; j < BLOCK_LENGTH; j++ ) {
				values[j / 4] |= ( bytes[i * BLOCK_LENGTH + j] & 0xff ) << ( ( 3 - j % 4 ) * 8 );
			}			
			for ( int j = 16; j < 80; j++ ) {
				values[j] = Integer.rotateLeft(values[j - 3] ^ values[j - 8] ^ values[j - 14] ^ values[j - 16], 1);
			}				
			
			int a = state[0], b = state[1], c = state[2], d = state[3], e = state[4];
			int f = 0, k = 0;
			for ( int j = 0; j < 80; j++ ) {
				switch ( j / 20 ) {
					case 0 -> { f = ( b & c ) | ( ~b & d );            k = 0x5a827999; }
					case 1 -> { f = b ^ c ^ d;                         k = 0x6ed9eba1; }
					case 2 -> { f = ( b & c ) | ( b & d ) | ( c & d ); k = 0x8f1bbcdc; }
					case 3 -> { f = b ^ c ^ d;                         k = 0xca62c1d6; }
				}

				int temp = Integer.rotateLeft(a, 5) + f + e + k + values[j];
				e = d; d = c; c = Integer.rotateLeft(b, 30); b = a; a = temp;
			}
			
			state[0] += a; state[1] += b; state[2] += c; state[3] += d; state[4] += e;
		}
		
		StringBuilder result = new StringBuilder();
        for ( int i = 0; i < 20; i++ ) {
        	result.append(String.format("%02x", ( state[i / 4] >>> 24 - ( i % 4 ) * 8 ) & 0xFF ));
        }
        return result.toString();
	}
	
	private static byte[] addPadding(String message) {
		byte[] bytes = message.getBytes(StandardCharsets.UTF_8);
		bytes = Arrays.copyOf(bytes, bytes.length + 1);
		bytes[bytes.length - 1] = (byte) 0x80;
				
		int padding = BLOCK_LENGTH - ( bytes.length % BLOCK_LENGTH );
		if ( padding < 8 ) {
			padding += BLOCK_LENGTH;			
		}	
		bytes = Arrays.copyOf(bytes, bytes.length + padding);
		
		final long bitLength = message.length() * 8;
		for ( int i = 0; i < 8; i++ ) {
			bytes[bytes.length - 1 - i] = (byte) ( bitLength >>> ( 8 * i ) );
		}
		return bytes;
	}
	
	private static final int BLOCK_LENGTH = 64;
	
}
