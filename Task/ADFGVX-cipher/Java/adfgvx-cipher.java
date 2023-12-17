import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Path;
import java.util.Arrays;
import java.util.Collections;
import java.util.List;
import java.util.stream.Collectors;

public final class ADFGVXCipher {

	public static void main(String[] args) throws IOException {	
		final char[][] polybius = initialisePolybiusSquare();
		System.out.println("The 6 x 6 Polybius square:");
		System.out.println(" | A D F G V X");
		System.out.println("--------------");
		for ( int row = 0; row < 6; row++ ) {
			System.out.print(ADFGVX.charAt(row) + "|");
			for ( int column = 0; column < 6; column++ ) {
				System.out.print(" " + polybius[row][column]);
			}
			System.out.println();
		}
		System.out.println();

		final String key = createKey(9);
		System.out.println("The key is " + key);
		System.out.println();
		final String plainText = "ATTACKAT1200AM";
		System.out.println("Plain text: " + plainText);
		System.out.println();
		final String encryptedText = encrypt(plainText, polybius, key);
		System.out.println("Encrypted: " + encryptedText);
		System.out.println();
		final String decryptedText = decrypt(encryptedText, polybius, key);
		System.out.println("Decrypted: " + decryptedText);		
	}
	
	private static String encrypt(String plainText, char[][] polybius, String key) {
		String code = "";
		for ( char ch : plainText.toCharArray() ) {
			for ( int row = 0; row < 6; row++ ) {
				for ( int column = 0; column < 6; column++ ) {
					if ( polybius[row][column] == ch ) {						
						code += ADFGVX.charAt(row) + "" + ADFGVX.charAt(column);
					}
				}
			}
		}
		
		String encrypted = "";
		for ( char ch : key.toCharArray() ) {
			for ( int i = key.indexOf(ch); i < code.length(); i += key.length() ) {
				encrypted += code.charAt(i);
			}
			encrypted += " ";
		}
		return encrypted;
	}
	
	private static String decrypt(String encryptedText, char[][] polybius, String key) {
		final int codeSize = encryptedText.replace(" ", "").length();		
		String code = "";
		for ( int i = 0; code.length() < codeSize; i++ ) {
			for ( String block : encryptedText.split(" ") ) {
				if ( code.length() < codeSize ) {
					code += block.charAt(i);
				}
			}
		}
		
		String plainText = "";
		for ( int i = 0; i < codeSize - 1; i += 2 ) {
		    int row = ADFGVX.indexOf(code.substring(i, i + 1));
		    int column = ADFGVX.indexOf(code.substring(i + 1, i + 2));
		    plainText += polybius[row][column];
		}		
		return plainText;	
	}
	
	// Create a key using a word from the dictionary 'unixdict.txt'
	private static String createKey(int size) throws IOException {
		if ( size < 7 || size > 12 ) {
			throw new AssertionError("Key should contain between 7 and 12 letters, both inclusive.");
		}
			
		List<String> candidates = Files.lines(Path.of("unixdict.txt"))
			.filter( word -> word.length() == size )
			.filter( word -> word.chars().distinct().count() == word.length() )
			.filter( word -> word.chars().allMatch(Character::isLetterOrDigit) )
			.collect(Collectors.toList());
		Collections.shuffle(candidates);
		return candidates.get(0).toUpperCase();		
	}
	
	private static char[][] initialisePolybiusSquare() {
		List<String> letters = Arrays.asList("ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789".split(""));
		Collections.shuffle(letters);
	
		char[][] result = new char[6][6];
		for ( int row = 0; row < 6; row++ ) {
		    for ( int column = 0; column < 6; column++ ) {
		        result[row][column] = letters.get(6 * row + column).charAt(0);
		    }
		}
		return result;
	}
	
	private static final String ADFGVX = "ADFGVX";	

}
