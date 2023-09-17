import java.util.ArrayList;
import java.util.List;

public final class RepStrings {

	public static void main(String[] aArgs) {
		List<String> tests = List.of( "1001110011", "1110111011", "0010010010",
			"1010101010", "1111111111", "0100101101", "0100100", "101", "11", "00", "1" );

		System.out.println("The longest rep-strings are:");
		for ( String test : tests ) {
			List<String> repeats = repString(test);
			String result = repeats.isEmpty() ? "Not a rep-string" : repeats.get(repeats.size() - 1);
			System.out.println(String.format("%10s%s%s", test, " -> ", result));
		}
	}
	
	private static List<String> repString(String aText) {
		List<String> repetitions = new ArrayList<String>();
		
		for ( int length = 1; length <= aText.length() / 2; length++ ) {
			String possible = aText.substring(0, length);
			int quotient = aText.length() / length;
			int remainder = aText.length() % length;
			String candidate = possible.repeat(quotient) + possible.substring(0, remainder);
			if ( candidate.equals(aText) ) {
				repetitions.add(possible);
			}
		}
		return repetitions;
	}

}
