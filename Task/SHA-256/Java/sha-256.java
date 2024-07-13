import java.nio.charset.StandardCharsets;
import java.util.Arrays;

public final class SHA256Task {

	public static void main(String[] args) {
		System.out.println(SHA256.messageDigest("Rosetta code"));
	}

}

final class SHA256 {
	
	public static String messageDigest(String message) {
		int[] hash = { 0x6a09e667, 0xbb67ae85, 0x3c6ef372, 0xa54ff53a,
					   0x510e527f, 0x9b05688c, 0x1f83d9ab, 0x5be0cd19 };
		
		final byte[] bytes = addPadding(message);			
		for ( int i = 0; i < bytes.length / BLOCK_LENGTH; i++ ) {
			int[] words = new int[BLOCK_LENGTH];
			for ( int j = 0; j < BLOCK_LENGTH; j++ ) {
				words[j / 4] |= ( bytes[i * BLOCK_LENGTH + j] & 0xff ) << ( ( 3 - j % 4 ) * 8 );
			}			
			for ( int j = 16; j < BLOCK_LENGTH; j++ ) {
				words[j] = sigma(3, words[j - 2]) + words[j - 7] + sigma(2, words[j - 15]) + words[j - 16];
			}		
			
			int a = hash[0], b = hash[1], c = hash[2], d = hash[3],
				e = hash[4], f = hash[5], g = hash[6], h = hash[7];
			
			for ( int j = 0; j < BLOCK_LENGTH; j++ ) {
				int t = h + sigma(1, e) + ch(e, f, g) + kk[j] + words[j];
				int tt = sigma(0, a) + maj(a, b, c);
				h = g; g = f; f = e;
				e = d + t;
				d = c; c = b; b = a;
				a = t + tt;
			}

		    hash[0] += a; hash[1] += b; hash[2] += c; hash[3] += d;
		    hash[4] += e; hash[5] += f; hash[6] += g; hash[7] += h;		
		}
		
		StringBuilder result = new StringBuilder();
        for ( int i = 0; i < BLOCK_LENGTH; i++ ) {
        	result.append(String.format("%1x", ( hash[i / 8] >>> ( 7 - i % 8 ) * 4 ) & 0xf ));
        }
        return result.toString();	
	}
	
	private static byte[] addPadding(String message) {
		byte[] bytes = message.getBytes(StandardCharsets.ISO_8859_1);
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
	
	private static int sigma(int group, int x) {
		return switch ( group ) {
			case 0 -> Integer.rotateRight(x,  2) ^ Integer.rotateRight(x, 13) ^ Integer.rotateRight(x, 22);
			case 1 -> Integer.rotateRight(x,  6) ^ Integer.rotateRight(x, 11) ^ Integer.rotateRight(x, 25);
			case 2 -> Integer.rotateRight(x,  7) ^ Integer.rotateRight(x, 18) ^ ( x >>>  3 );
			case 3 -> Integer.rotateRight(x, 17) ^ Integer.rotateRight(x, 19) ^ ( x >>> 10 );
			default -> throw new AssertionError("Unexpected argument for sigma: " + group);
		};
	}
	
	private static int ch(int x, int y, int z) {
		return ( x & y ) ^ ( ~x & z );
	}

	private static int maj(int x, int y, int z) {
		return ( x & y ) ^ ( x & z ) ^ ( y & z );
	}
	
	private static final int[] kk = new int[] {
		0x428a2f98, 0x71374491, 0xb5c0fbcf, 0xe9b5dba5, 0x3956c25b, 0x59f111f1, 0x923f82a4, 0xab1c5ed5,
        0xd807aa98, 0x12835b01, 0x243185be, 0x550c7dc3, 0x72be5d74, 0x80deb1fe, 0x9bdc06a7, 0xc19bf174,
        0xe49b69c1, 0xefbe4786, 0x0fc19dc6, 0x240ca1cc, 0x2de92c6f, 0x4a7484aa, 0x5cb0a9dc, 0x76f988da,
        0x983e5152, 0xa831c66d, 0xb00327c8, 0xbf597fc7, 0xc6e00bf3, 0xd5a79147, 0x06ca6351, 0x14292967,
        0x27b70a85, 0x2e1b2138, 0x4d2c6dfc, 0x53380d13, 0x650a7354, 0x766a0abb, 0x81c2c92e, 0x92722c85,
        0xa2bfe8a1, 0xa81a664b, 0xc24b8b70, 0xc76c51a3, 0xd192e819, 0xd6990624, 0xf40e3585, 0x106aa070,
        0x19a4c116, 0x1e376c08, 0x2748774c, 0x34b0bcb5, 0x391c0cb3, 0x4ed8aa4a, 0x5b9cca4f, 0x682e6ff3,
        0x748f82ee, 0x78a5636f, 0x84c87814, 0x8cc70208, 0x90befffa, 0xa4506ceb, 0xbef9a3f7, 0xc67178f2 };	
	
	private static final int BLOCK_LENGTH = 64;
	
}
