import java.util.HashSet;
import java.util.List;
import java.util.OptionalInt;
import java.util.Set;

public final class DetermineUniqueCharacters {

	public static void main(String[] aArgs) {
		List<String> words = List.of( "", ".", "abcABC", "XYZ ZYX", "1234567890ABCDEFGHIJKLMN0PQRSTUVWXYZ" );
		
		for ( String word : words ) {		
			Set<Integer> seen = new HashSet<Integer>();
	        OptionalInt first = word.chars().filter( ch -> ! seen.add(ch) ).findFirst();
	        if ( first.isPresent() ) {	
	            final char ch = (char) first.getAsInt();
	            final String hex = Integer.toHexString(ch).toUpperCase();
	            System.out.println("Word: \"" + word + "\" contains a repeated character.");
	            System.out.println("Character '" + ch + "' (hex " + hex + ") occurs at positions "
	            	+ word.indexOf(ch) + " and " + word.indexOf(ch, word.indexOf(ch) + 1));
	        } else {
	        	System.out.println("Word: \"" + word + "\" has all unique characters.");
	        }
	        System.out.println();			
		}
	}

}
