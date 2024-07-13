import java.math.BigInteger;
import java.nio.charset.StandardCharsets;
import java.util.Arrays;
import java.util.stream.Collectors;

public final class BitcoinPublicPointToAddess {

	public static void main(String[] args) {
		String x = "50863AD64A87AE8A2FE83C1AF1A8403CB53F53E486D8511DAD8A04887E5B2352";
        String y = "2CD470243453A299FA9E77237716103ABC11A1DF38855ED6F2EE187E9C582BA6";

		if ( areValidCoordinates(x, y) ) {
			System.out.println(encodeAddress(x, y));
		} else {
			System.out.println("Invalid Bitcoin public point coordinates");
		}
	}
	
	//  Return the encoded address of the given coordinates.
	private static String encodeAddress(String x, String y) {
	    String publicPoint = BITCOIN_SPECIAL_VALUE + x + y;	
	    if ( publicPoint.length() != 130 ) {
	        throw new AssertionError("Invalid public point string: " + publicPoint);
	    }

	    byte[] messageBytes = computeMessageBytes(publicPoint);	
	    byte[] checksum = computeChecksum(messageBytes);
	   	messageBytes = Arrays.copyOf(messageBytes, messageBytes.length + 4);
	   	System.arraycopy(checksum, 0, messageBytes, 21, checksum.length);
	   	return encodeBase58(messageBytes);
	}
	
	// Return the given byte array encoded into a base58 starting with most one '1'
	private static String encodeBase58(byte[] bytes) {
	    final String ALPHABET = "123456789ABCDEFGHJKLMNPQRSTUVWXYZabcdefghijkmnopqrstuvwxyz";
	    final int ALPHABET_SIZE = ALPHABET.length();
	
	    String[] temp = new String[34];
        for ( int n = temp.length - 1; n >= 0; n-- ) {
            int c = 0;
            for ( int i = 0; i < bytes.length; i++ ) {
                c = c * 256 + (int) ( bytes[i] & 0xFF );
                bytes[i] = (byte) ( c / ALPHABET_SIZE );
                c %= ALPHABET_SIZE;
            }
            temp[n] = ALPHABET.substring(c, c + 1);
        }

        String result = Arrays.stream(temp).collect(Collectors.joining(""));
	    while ( result.startsWith("11") ) {
	       result = result.substring(1);
	    }
	    return result;
	}
	
	// Return whether the given coordinates are those of a point on the secp256k1 elliptic curve
	private static boolean areValidCoordinates(String x, String y) {
		BigInteger modulus = new BigInteger("FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFEFFFFFC2F", 16);
		BigInteger X = new BigInteger(x, 16);
		BigInteger Y = new BigInteger(y, 16);
		return Y.multiply(Y).mod(modulus).equals(X.multiply(X).multiply(X).add(BigInteger.valueOf(7)).mod(modulus));
	}
	
	private static byte[] computeMessageBytes(String text) {
		// Convert the hexadecimal string 'text' into a suitable ASCII string for the SHA256 hash
	    byte[] bytesOne = hexToBytes(text);
	    String asciiOne = new String(bytesOne, StandardCharsets.ISO_8859_1);
	    String hexSHA256 = SHA256.messageDigest(asciiOne);	
	    // Convert the hexadecimal string 'hexSHA256' into a suitable ASCII string for the RIPEMD160 hash
	 	byte[] bytesTwo = hexToBytes(hexSHA256);	 	
	 	String asciiTwo = new String(bytesTwo, StandardCharsets.ISO_8859_1);
	 	String hexRIPEMD160 = BITCOIN_VERSION_NUMBER + RIPEMD160.messageDigest(asciiTwo);	 	
	 	return hexToBytes(hexRIPEMD160);
	}
	
	private static byte[] computeChecksum(byte[] bytes) {
		// Convert the given byte array into a suitable ASCII string for the first SHA256 hash
		String asciiOne = new String(bytes, StandardCharsets.ISO_8859_1);
	 	String hexOne = SHA256.messageDigest(asciiOne);
	 	// Convert the hexadecimal string 'hex1' into a suitable ASCII string for the second SHA256 hash
	 	byte[] bytesOne = hexToBytes(hexOne);
	 	String asciiTwo = new String(bytesOne, StandardCharsets.ISO_8859_1);
	 	String hexTwo = SHA256.messageDigest(asciiTwo);
	 	return Arrays.copyOfRange(hexToBytes(hexTwo), 0, 4);
	}
	
	private static byte[] hexToBytes(String text) {
		byte[] bytes = new byte[text.length() / 2];
	    for ( int i = 0; i < text.length(); i += 2 ) {
	    	 final int firstDigit = Character.digit(text.charAt(i), 16);
	    	 final int secondDigit = Character.digit(text.charAt(i + 1), 16);
	         bytes[i / 2] = (byte) ( ( firstDigit << 4 ) + secondDigit );;
	    }
	    return bytes;
	}
	
	private static final String BITCOIN_SPECIAL_VALUE = "04";
	private static final String BITCOIN_VERSION_NUMBER = "00";
}
