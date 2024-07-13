import java.nio.charset.StandardCharsets;
import java.util.Arrays;
import java.util.List;

public final class BitcoinAddressValidation {

	public static void main(String[] args) {
		List<String> addresses = List.of ( "1AGNa15ZQXAZUgFiqJ2i7Z2DPU2J6hW62i",
										   "1AGNa15ZQXAZUgFiqJ2i7Z2DPU2J6hW62j",
										   "1Q1pE5vPGEEMqRcVRMbtBK842Y6Pzo6nK9",
										   "1AGNa15ZQXAZUgFiqJ2i7Z2DPU2J6hW62X",
										   "1ANNa15ZQXAZUgFiqJ2i7Z2DPU2J6hW62i" );					
		
		for ( String address : addresses ) {
			System.out.println(address + " : " + isValid(address));
		}
	}
	
	private static boolean isValid(String address) {
		if ( address.length() < 26 || address.length() > 35 ) {
			throw new AssertionError("Invalid length of bitcoin address");
		}		
		
		byte[] decoded = decodeBase58(address);			
		byte[] first21 = Arrays.copyOfRange(decoded, 0, 21);		
		// Convert 'first21' into an ASCII string for the first SHA256 hash
		String text = new String(first21, StandardCharsets.ISO_8859_1);	
		String hashOne = SHA256.messageDigest(text);		
		// Convert 'hashOne' into an ASCII string for the second SHA256 hash
		byte[] bytesOne = hexToBytes(hashOne);	
		String asciiOne = new String(bytesOne, StandardCharsets.ISO_8859_1);		
		String hashTwo = SHA256.messageDigest(asciiOne);
				
		byte[] bytesTwo = hexToBytes(hashTwo);			
		byte[] checksum = Arrays.copyOfRange(bytesTwo, 0, 4);		
		byte[] last4 = Arrays.copyOfRange(decoded, 21, 25);	
		return Arrays.equals(last4, checksum);		
	}
	
	private static byte[] decodeBase58(String text) {
        byte[] result = new byte[25];
        for ( char ch : text.toCharArray() ) {
            int index = ALPHABET.indexOf(ch);
            if ( index == -1 ) {
            	throw new AssertionError("Invalid character found in bitcoin address: " + ch);
            }
            for ( int i = result.length - 1; i > 0; i-- ) {
                index += 58 * (int) ( result[i] & 0xFF );
                result[i] = (byte) ( index & 0xFF );
                index >>= 8;
            }
            if ( index != 0 ) {
            	throw new AssertionError("Bitcoin address is too long");
            }
        }
        return result;
    }
	
	private static byte[] hexToBytes(String text) {
		byte[] bytes = new byte[text.length() / 2];
	    for ( int i = 0; i < text.length(); i += 2 ) {
	    	 final int firstDigit = Character.digit(text.charAt(i), 16);
	    	 final int secondDigit = Character.digit(text.charAt(i + 1), 16);
	         bytes[i / 2] = (byte) ( ( firstDigit << 4 ) + secondDigit );
	    }
	    return bytes;
	}

	private static final String ALPHABET = "123456789ABCDEFGHJKLMNPQRSTUVWXYZabcdefghijkmnopqrstuvwxyz";  	

}
