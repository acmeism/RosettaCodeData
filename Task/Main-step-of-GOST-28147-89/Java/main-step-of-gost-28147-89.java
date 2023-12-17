import java.nio.charset.Charset;
import java.nio.charset.StandardCharsets;
import java.util.ArrayList;
import java.util.List;
import java.util.function.IntUnaryOperator;
import java.util.stream.Collectors;
import java.util.stream.IntStream;

/**
 * Encrypt and decrypt messages in unicode characters using the GOST 28147-89 (Magma) algorithm.
 *
 * For further information visit https://en.wikipedia.org/wiki/GOST_(block_cipher)
 */
public final class MainStepGOST28147_89 {

	public static void main(String[] aArgs) {
		// Initialisation
		String plainText = "The spy 我 lives in Iž";
		GOST28147_89 gost = new GOST28147_89(plainText);		
				
		// Display the plain text and the plain text bytes		
		System.out.println("The plain text is:     \"" + plainText + "\"" + System.lineSeparator());
		String plainTextBinary = gost.getPlainTextBinary();	
		displayBytesFromBinary("The plain text bytes are:     ", plainTextBinary);
				
		// Encryption		
		String encryptedBinary = gost.gostAlgorithm(plainTextBinary, Cryptation.ENCRYPT);
		
		// Display the encrypted text bytes and the encrypted text
		List<Character> encryptedChars = displayBytesFromBinary("The encrypted text bytes are: ", encryptedBinary);
		String encryptedText = encryptedChars.stream().map(String::valueOf).collect(Collectors.joining());
		System.out.println("The encrypted text is: \"" + encryptedText + "\"" + System.lineSeparator());
			
		// Decryption		
		String decryptedBinary = gost.gostAlgorithm(encryptedBinary, Cryptation.DECRYPT);
		
		// Display the decrypted text bytes and the decrypted text
		List<Character> decryptedChars = displayBytesFromBinary("The decrypted text bytes are: ", decryptedBinary);
		byte[] bytes = new byte[decryptedChars.size()];
		IntStream.range(0, decryptedChars.size()).forEach( i -> bytes[i] = (byte) decryptedChars.get(i).charValue() );
		System.out.println("The decrypted text is: \"" + new String(bytes) + "\"" + System.lineSeparator());
	}
	
	/**
	 * Display the given tile string together with a list of bytes obtained from the given binary string.
	 * Return a list of characters obtained from the given binary string.
	 */
	private static List<Character> displayBytesFromBinary(String aTitle, String aBinaryBlock) {
		List<Character> chars = new ArrayList<Character>();
		List<String> bytes = new ArrayList<String>();	
		for ( int i = 0; i < aBinaryBlock.length(); i += 8 ) {
			char ch = (char) Integer.parseInt(aBinaryBlock.substring(i, i + 8), 2);
			chars.add(ch);
			bytes.add(String.format("%2s", Integer.toHexString(ch)).replace(" ", "0"));
		}
		
		System.out.println(aTitle);
		for ( int i = 0; i < bytes.size(); i += 8 ) {
			System.out.print(bytes.subList(i, i + 8));
		}
		System.out.println(System.lineSeparator());
		
		return chars;
	}	
	
}

enum Cryptation { ENCRYPT, DECRYPT }

final class GOST28147_89 {
	
	public GOST28147_89(String aPlainText) {
		createSbox();
		createKeys();
		plainTextBinary = convertCharactersToBinary(aPlainText, StandardCharsets.UTF_8);
	}
	
	/**
	 * Encrypt or decrypt the given binary string according to the value of the given enum,
	 * using the GOST 28147-89 (Magma) algorithm.
	 */
	public String gostAlgorithm(String aBinaryBlock, Cryptation aCryptation) {
		StringBuilder stringBuilder = new StringBuilder();
		for ( int i = 0; i < aBinaryBlock.length(); i += 64 ) {
			String one = reverse(aBinaryBlock.substring(i, i + 32));
			String two = reverse(aBinaryBlock.substring(i + 32, i + 64));
			
			List<String> pair;
			switch ( aCryptation ) {
				case ENCRYPT -> { pair = mainStep(one, two, 24, k -> k % 8);
							  	  pair = mainStep(pair.get(0), pair.get(1), 8, k -> 7 - k);
							  	  stringBuilder.append(reverse(pair.get(0)));
	        					  stringBuilder.append(reverse(pair.get(1)));
								}
				case DECRYPT -> { pair = mainStep(two, one, 8, k -> k);
							 	  pair = mainStep(pair.get(0), pair.get(1), 24, k -> 7 - k % 8);
							 	  stringBuilder.append(reverse(pair.get(1)));
		        				  stringBuilder.append(reverse(pair.get(0)));
								}
			};
		}
			
		return stringBuilder.toString();			
	}	
	
	public String getPlainTextBinary() {
		return plainTextBinary;
	}
	
	// PRIVATE //

	/**
	 * Perform the main step of the GOST 28147-89 (Magma) algorithm.
	 */
	private List<String> mainStep(String aLeft, String aRight, int aIterations, IntUnaryOperator aOperator) {
		for ( int i = 0; i < aIterations; i++ ) {
			long sum = Long.parseLong(aRight, 2) + Integer.parseInt(keys.get(aOperator.applyAsInt(i)), 2);
			sum %= Math.pow(2, 32);
			String newSum = String.format("%32s", Long.toBinaryString(sum)).replace(" ", "0");
			newSum = shiftLeft(sBoxFunction(newSum));
			
			String temp = aLeft;
			aLeft = aRight;			
			long xor = Long.parseLong(newSum, 2) ^ Long.parseLong(temp, 2);			
			aRight = String.format("%32s", Long.toBinaryString(xor)).replace(" ", "0");
		}
		
		return List.of(aLeft, aRight);
	}	
	
	/**
	 * Convert each byte in the given string to its ASCII code value as a binary number,
	 * and concatenate these binary numbers into a single string.
	 * Pad the resulting string so that its length is a multiple of 8 bytes which is 64 bits.
	 */
	private String convertCharactersToBinary(String aBytes, Charset aCharset) {
		StringBuilder stringBuilder = new StringBuilder();
		for ( byte bbyte : aBytes.getBytes(aCharset) ) {
			String binary = String.format("%8s", Integer.toBinaryString(bbyte & 0xff)).replace(" ", "0");
			stringBuilder.append(binary);				
		}
		String binaryBlock = stringBuilder.toString();
		
		while ( binaryBlock.length() % 64 > 0 ) {
			binaryBlock += "00100000"; // The ASCII code for the space character as a binary number.
		}
		
		return binaryBlock;
	}
	
	/**
	 * Left shift the given string by 11 bits.
	 */
	private String shiftLeft(String aBinaryBlock) {
		return aBinaryBlock.substring(11) + aBinaryBlock.substring(0, 11);
	}
	
	/**
	 * Return the reverse of the given string.
	 */
	private String reverse(String aText) {
		return new StringBuilder(aText).reverse().toString();
	}	
	
	/**
	 * Convert the 32 character KEY_TEXT into a 256 bit binary string.
	 * Then convert this string into 8 keys each consisting of a 32 bit string.
	 */
	private void createKeys() {
		if ( KEY_TEXT.length() != 32 ) {
			throw new AssertionError("The KEY_TEXT must contain exactly 32 characters");
		}
	
		String binaryKey = convertCharactersToBinary(KEY_TEXT, StandardCharsets.UTF_8);	
	    keys = new ArrayList<String>();
	    for ( int i = 0; i < 256; i += 32 ) {	    	
	        keys.add( new String(binaryKey.substring(i, i + 32)) );
	    }
	}
	
	/**
	 * Split the given 32 bit string into 8 parts,
	 * and replace each part with its respective hexadecimal number from the sBox.
	 */
	private String sBoxFunction(String aBinaryBlock) {
		StringBuilder result = new StringBuilder();
		for ( int i = 0; i < 32; i += 4 ) {
			int number = Integer.parseInt(aBinaryBlock.substring(i, i + 4), 2);			
			int boxNumber = Integer.parseInt(sBox.get(i / 4).substring(number, number + 1), 16);			
			String binary = Integer.toBinaryString(boxNumber).replace(" ", "0");		
			result.append(binary);
		}
		
		return result.toString();
	}
	
	/**
	 * Create a list of strings of hexadecimal digits.
	 */
	private void createSbox() {
		sBox = List.of(
			"4A92D80E6B1C7F53",
			"EB4C6DFA23810759",
			"581DA342EFC7609B",
			"7DA1089FE46CB253",
			"6C715FD84A9E03B2",
			"4BA0721D36859CFE",
			"DB413F590AE7682C",
			"1FD057A4923E6B8C");
	}	
	
	private List<String> sBox;
	private List<String> keys;
	private String plainTextBinary;
	
	// The KEY_TEXT must contain exactly 32 characters.
	private final String KEY_TEXT = "Kriptografi Metode GOST, Andysah";		
	
}
