import java.util.OptionalInt;

public final class AllSameCharacters {

	public static void main(String[] aArgs) {
		String[] words = { "", "   ", "2", "333", ".55", "tttTTT", "4444 444k" };
		for ( String word : words ) {
			analyse(word);
		}		
	}
	
	private static void analyse(String aText) {
		System.out.println("Examining \"" + aText + "\", which has length " + aText.length() + ":");

		OptionalInt mismatch = aText.chars().filter( ch -> ch != aText.charAt(0) ).findFirst();		
		
		if ( mismatch.isPresent() ) {
			char fault = (char) mismatch.getAsInt();
			System.out.println("    Not all characters in the string are the same.");
			System.out.println("    Character \"" + fault + "\" (" + Integer.toHexString((char) fault)
			                        + ") is different at index " + aText.indexOf(fault));
		} else {
			System.out.println("    All characters in the string are the same.");			
		}		
	}

}
