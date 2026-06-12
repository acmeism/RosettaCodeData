import java.util.ArrayList;
import java.util.HashSet;
import java.util.List;
import java.util.Set;

public final class LongestSubstringsWithoutRepeatingCharacters {

	public static void main(String[] args) {
		System.out.println("The longest substring(s) of the following without repeating characters are:");
		System.out.println();
		List<String> tests = List.of( "xyzyabcybdfd", "xyzyab", "zzzzz", "a", "" );
		
		tests.forEach( test -> {
			List<String> result = new ArrayList<String>();
		    int longestLength = 0;
		    for ( String substring : allSubstrings(test) ) {
		    	if ( substring.length() == substring.chars().distinct().count() ) {		    	
		            if ( substring.length() >= longestLength ) {
		                if ( substring.length() > longestLength ) {
		                    result.clear();
		                    longestLength = substring.length();
		                }
		                result.addLast(substring);
		            }
		    	}
	        }
		
    	    System.out.println("String = '" + test + "' => " + result
                + " with length = " + result.getFirst().length());
		} );
	}
	
	private static Set<String> allSubstrings(String text) {
	    Set<String> result = new HashSet<String>();
	    result.add("");

	    for ( int i = 0; i < text.length(); i++ ) {
	        for ( int j = i + 1; j <= text.length(); j++ ) {
	            result.add(text.substring(i, j));
	        }
	    }
	    return result;
	}

}
