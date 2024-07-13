import java.nio.charset.StandardCharsets;
import java.util.Arrays;

public final class RIPEMD160Task {

	public static void main(String[] aArgs) {
		System.out.println(RIPEMD160.messageDigest("Rosetta Code"));		
	}

}

final class RIPEMD160 {
	
	public static String messageDigest(String aMessage) {
		int[] state = { 0x67452301, 0xefcdab89, 0x98badcfe, 0x10325476, 0xc3d2e1f0 };
		
		byte[] bytes = addPadding(aMessage);	
		for ( int i = 0; i < bytes.length / BLOCK_LENGTH; i++ ) {			
			int[] schedule = new int[16];
            for ( int j = 0; j < BLOCK_LENGTH; j++ ) {
                schedule[j / 4] |= ( bytes[i * BLOCK_LENGTH + j] & 0xff ) << ( j % 4 * 8 );
            }
			
			int a = state[0], b = state[1], c = state[2], d = state[3], e = state[4];
		    int aa = state[0], bb = state[1], cc = state[2], dd = state[3], ee = state[4];
		    int t = 0, tt = 0;
		
		    for ( int j = 0; j < 80; j++ ) {
		    	int jj = j / 16;
		    	t = Integer.rotateLeft(a + ff(jj + 1, b, c, d) + schedule[RL[j]] + KL[jj], SL[j]) + e;
 		        tt = Integer.rotateLeft(aa + ff(5 - jj, bb, cc, dd) + schedule[RR[j]] + KR[jj], SR[j]) + ee;
 		    		
 		        a = e; e = d; d = Integer.rotateLeft(c, 10); c = b; b = t;
		    	aa = ee; ee = dd; dd = Integer.rotateLeft(cc, 10); cc = bb; bb = tt;
		     }
		
		     t        = state[1] + c + dd;
		     state[1] = state[2] + d + ee;
		     state[2] = state[3] + e + aa;
		     state[3] = state[4] + a + bb;
		     state[4] = state[0] + b + cc;
		     state[0] = t;
		}	

        String result = "";
        for ( int i = 0; i < state.length * 4; i++ ) {
        	result += String.format("%02x", (byte) ( state[i / 4] >>> ( i % 4 * 8 ) ));
        }
        return result;		
	}
	
	private static byte[] addPadding(String aMessage) {
		byte[] bytes = aMessage.getBytes(StandardCharsets.ISO_8859_1);
		bytes = Arrays.copyOf(bytes, bytes.length + 1);
		bytes[bytes.length - 1] = (byte) 0x80;		
				
		int padding = BLOCK_LENGTH - ( bytes.length % BLOCK_LENGTH );
		if ( padding < 8 ) {
			padding += BLOCK_LENGTH;			
		}	
		bytes = Arrays.copyOf(bytes, bytes.length + padding);
		
		final long bitLength = aMessage.length() * 8;
		for ( int i = 0; i < 8; i++ ) {
			bytes[bytes.length - 8 + i] = (byte) ( bitLength >>> ( 8 * i ) );
		}
		return bytes;
	}
	
	private static int ff(int aGroup, int aX, int aY, int aZ) {
		return switch ( aGroup ) {
			case 1 -> aX ^ aY ^ aZ;
			case 2 -> ( aX & aY ) | ( ~aX & aZ );
			case 3 -> ( aX | ~aY ) ^ aZ;
			case 4 -> ( aX & aZ ) | ( aY & ~aZ );
			case 5 -> aX ^ ( aY | ~aZ );
			default -> throw new IllegalArgumentException("Unexpected argument: " + aGroup);
		};
	}
	
	private static final int[] KL = new int[] { 0x00000000, 0x5a827999, 0x6ed9eba1, 0x8f1bbcdc, 0xa953fd4e };
	private static final int[] KR = new int [] { 0x50a28be6, 0x5c4dd124, 0x6d703ef3, 0x7a6d76e9, 0x00000000 };
	
	private static final int[] RL = new int[] {  0,  1,  2,  3,  4,  5,  6,  7,  8,  9, 10, 11, 12, 13, 14, 15,
												 7,  4, 13,  1, 10,  6, 15,  3, 12,  0,  9,  5,  2, 14, 11,  8,
		    								     3, 10, 14,  4,  9, 15,  8,  1,  2,  7,  0,  6, 13, 11,  5, 12,
		    								     1,  9, 11, 10,  0,  8, 12,  4, 13,  3,  7, 15, 14,  5,  6,  2,
		    								     4,  0,  5,  9,  7, 12,  2, 10, 14,  1,  3,  8, 11,  6, 15, 13 };
	
	private static final int[] RR = new int[] {  5, 14,  7,  0,  9,  2, 11,  4, 13,  6, 15,  8,  1, 10,  3, 12,
											     6, 11,  3,  7,  0, 13,  5, 10, 14, 15,  8, 12,  4,  9,  1,  2,
												15,  5,  1,  3,  7, 14,  6,  9, 11,  8, 12,  2, 10,  0,  4, 13,
												 8,  6,  4,  1,  3, 11, 15,  0,  5, 12,  2, 13,  9,  7, 10, 14,
												12, 15, 10,  4,  1,  5,  8,  7,  6,  2, 13, 14,  0,  3,  9, 11 };
	
	private static final int[] SL = new int[] { 11, 14, 15, 12,  5,  8,  7,  9, 11, 13, 14, 15,  6,  7,  9,  8,
											     7,  6,  8, 13, 11,  9,  7, 15,  7, 12, 15,  9, 11,  7, 13, 12,
											    11, 13,  6,  7, 14,  9, 13, 15, 14,  8, 13,  6,  5, 12,  7,  5,
											    11, 12, 14, 15, 14, 15,  9,  8,  9, 14,  5,  6,  8,  6,  5, 12,
											     9, 15,  5, 11,  6,  8, 13, 12,  5, 12, 13, 14, 11,  8,  5,  6 };
	
	private static final int[] SR = new int[] {  8,  9,  9, 11, 13, 15, 15,  5,  7,  7,  8, 11, 14, 14, 12,  6,
		    					    			 9, 13, 15,  7, 12,  8,  9, 11,  7,  7, 12,  7,  6, 15, 13, 11,
		    									 9,  7, 15, 11,  8,  6,  6, 14, 12, 13,  5, 14, 13, 13,  7,  5,
		    									15,  5,  8, 11, 14, 14,  6, 14,  6,  9, 12,  9, 12,  5, 15,  8,
		    									 8,  5, 12,  9, 12,  5, 14,  6,  8, 13,  6,  5, 15, 13, 11, 11 };	
	
	private static final int BLOCK_LENGTH = 64;
		
}
