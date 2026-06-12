import java.util.ArrayList;
import java.util.List;
import java.util.stream.Collectors;

public final class LongestPalindromicSubstrings {

	public static void main() {
		List<String> tests = List.of("three old rotators",
									 "never reverse",
									 "stable was I ere I saw elbatrosses",
									 "abracadabra",
									 "drome",
									 "the abbatial palace",
									 "",
									 "aabccdeff");
		
		tests.forEach( test -> 			
			IO.println("The longest palindromic substrings of \"" + test + "\" are: " + manacher(test)) );
	}
	
	/**
	 * Return the longest palindromic substrings of the given string.
	 *
	 * Uses Manacher's algorithm; for more information visit
	 * https://cp-algorithms.com/string/manacher.html
	 */
	private static List<String> manacher(String text) {
		List<String> result = new ArrayList<String>();
		if ( text.isEmpty() ) {
			return result;
		}
		
		String word = "$" + "#"
			+ text.chars().mapToObj( i -> Character.toString(i) + "#" ).collect(Collectors.joining("")) + "@";	
		
	    int[] pals = new int[word.length()];
	    int centre = 1;
	    int right = 1;
	
	    for ( int i = 2; i < word.length() - 1; i++ ) {	    	
	        if ( right > i && pals[2 * centre - i] > 0 ) {
	        	pals[i] = 1;
	        }
	
	        while ( word.charAt(i + pals[i] + 1) == word.charAt(i - pals[i] - 1) ) {
	            pals[i] += 1;
	        }
	
	        if ( i + pals[i] > right ) {
	            centre = i;
	            right = i + pals[i];
	        }
	    }
	
	    int maxLength = 0;
	    List<Integer> indexes = new ArrayList<Integer>();
	    for ( int index = 0; index < pals.length; index++ ) {
	    	if ( pals[index] > maxLength ) {
	    		maxLength = pals[index];
	    		indexes.clear();
	    		indexes.addLast(index);
	    	} else if ( pals[index] == maxLength ) {
	    		indexes.addLast(index);
	    	}
	    }	
	
	    for ( int index : indexes ) {
	    	final int begin = ( index - maxLength ) / 2;
		    final int end = ( index + maxLength ) / 2;
		    result.addLast(text.substring(begin, end));
	    }

	    return result;
	}

}
