import java.util.Arrays;
import java.util.List;
import java.util.Map;

public final class NamesToNumbers {

	public static void main(String[] args) {
		List<String> tests = List.of(
	        "none",
	        "one",
	        "twenty-five",
	        "minus one hundred and seventeen",
	        "hundred and fifty-six",
	        "minus two thousand two",
	        "nine thousand, seven hundred, one",
	        "minus six hundred and twenty six thousand, eight hundred and fourteen",
	        "four million, seven hundred thousand, three hundred and eighty-six",
	        "fifty-one billion, two hundred and fifty-two million, seventeen thousand,"
	        + " one hundred eighty-four",
	        "two hundred and one billion, twenty-one million, two thousand and one",
	        "minus three hundred trillion, nine million, four hundred and one thousand and thirty-one",
	        "seventeen quadrillion, one hundred thirty-seven",
	        "a quintillion, eight trillion and five",
	        "minus nine quintillion, two hundred and twenty-three quadrillion,"
	        + " three hundred and seventy-two trillion, thirty-six billion,"
	        + " eight hundred and fifty-four million, seven hundred and seventy-five thousand,"
	        + " eight hundred and eight" );
		
		tests.forEach( test ->
			System.out.println(String.format("%20s%s%s", nameToNumber(test), " = ", test)) );
	}
	
	private static long nameToNumber(String name) {
	    String text = name.trim().toLowerCase();
	    final boolean isNegative = text.startsWith("minus ");
	    if ( isNegative ) {
	    	text = text.substring(6);
	    }
	    if ( text.startsWith("a ") ) {
	    	text = "one" + text.substring(1);
	    }
	    String[] words = text.split(" and |-| |,");
	    words = Arrays.stream(words).filter( s -> ! s.isBlank() ).toArray(String[]::new);
	    if ( words.length == 1 && ZEROS.contains(words[0]) ) {
	    	return 0;
	    }
	
	    long multiplier = 1;
	    long lastNumber = 0;
	    long sum = 0;
	    for ( int i = words.length - 1; i >= 0; i-- ) {
	    	if ( ! NAMES.containsKey(words[i]) ) {
	    		throw new IllegalArgumentException("'" + words[i] + "' is not a valid number");
	    	}	
	    	
	        long number = NAMES.get(words[i]);
	        if ( number == lastNumber ) {
	            throw new IllegalArgumentException("'" + name + "' is not a well formed numeric string");
	        } else if ( number >= 1_000 ) {
	            if ( lastNumber >= 100 ) {
	                throw new IllegalArgumentException("'" + name + "' is not a well formed numeric string");
	            }
	            multiplier = number;
	            if ( i == 0 ) {
	            	sum += multiplier;
	            }
	        } else if ( number >= 100 ) {
	            multiplier *= 100;
	            if ( i == 0 ) {
	            	sum += multiplier;
	            }
	        } else if ( number >= 20 ) {
	            if ( lastNumber >= 10 && lastNumber <= 90 ) {
	                throw new IllegalArgumentException("'" + name + "' is not a well formed numeric string");
	            }
	            sum += number * multiplier;
	        } else {
	            if ( lastNumber >= 1 && lastNumber <= 90 ) {
	                throw new IllegalArgumentException("'" + name + "' is not a well formed numeric string");
	            }
	            sum += number * multiplier;
	        }
	
	        lastNumber = number;
	    }
	
	    if ( isNegative && sum == -sum ) {
	        return Long.MIN_VALUE;
	    }
	    if ( sum < 0 ) {
	        throw new IllegalArgumentException("'" + name + "' is outside the range of a long integer");
	    }
	    return isNegative ? -sum : sum;	    		
	}
	
	private static final Map<String, Long> NAMES = Map.ofEntries(
		Map.entry("one", 1L), Map.entry("two", 2L), Map.entry("three", 3L), Map.entry("four", 4L),
		Map.entry("five", 5L), Map.entry("six", 6L), Map.entry("seven", 7L), Map.entry("eight", 8L),
		Map.entry("nine", 9L), Map.entry("ten", 10L), Map.entry("eleven", 11L), Map.entry("twelve", 12L),
		Map.entry("thirteen", 13L), Map.entry("fourteen", 14L), Map.entry("fifteen", 15L),
		Map.entry("sixteen", 16L), Map.entry("seventeen", 17L), Map.entry("eighteen", 18L),
		Map.entry("nineteen", 19L), Map.entry("twenty", 20L), Map.entry("thirty", 30L),
		Map.entry("forty", 40L), Map.entry("fifty", 50L), Map.entry("sixty", 60L), Map.entry("seventy", 70L),
		Map.entry("eighty", 80L), Map.entry("ninety", 90L), Map.entry("hundred", 100L),
		Map.entry("thousand", 1_000L), Map.entry("million", 1_000_000L),
		Map.entry("billion", 1_000_000_000L), Map.entry("trillion", 1_000_000_000_000L),
		Map.entry("quadrillion", 1_000_000_000_000_000L),
		Map.entry("quintillion", 1_000_000_000_000_000_000L) );
			
	private static final List<String> ZEROS = List.of( "zero", "nought", "nil", "none", "nothing" );
			
}
