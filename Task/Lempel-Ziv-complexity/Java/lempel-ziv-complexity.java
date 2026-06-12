import java.util.List;

public final class LempelZivComplexity {

	public static void main() {
		List<String> tests = List.of( "AZSEDRFTGYGUJIJOKB",
				                      "ABCABCABCABCABCABC",
				                      "111011111001111011111001",
				                      "101001010010111110",
				                      "1001111011000010",
				                      "1010101010",
				                      "1010101010101010",
				                      "1001111011000010000010",
				                      "100111101100001000001010",
				                      "0001101001000101",
				                      "1111111",
				                      "0001",
				                      "010",
				                      "1",
				                      "",
				                      "01011010001101110010",
				                      "ABCDEFGHIJKLMNOPQRSTUVWXYZ",
				                      "HELLO WORLD! HELLO WORLD! HELLO WORLD! HELLO WORLD!" );
		
		 IO.println("%-52s%s".formatted("String", "LZ Complexity"));
		 IO.println("=".repeat(65));
		
		 tests.forEach( test -> IO.println("%-52s%d".formatted(test, lempelZivComplexity(test))) );
	}
	
	private static int lempelZivComplexity(String text) {
	    if ( text.isEmpty() ) {
	        return 0;
	    }
	
	    int complexity = 0;
	    int pointer = 0;
	
	    while ( pointer < text.length() ) {
	        complexity += 1;
	        int k = 1;
	        while ( pointer + k <= text.length() ) {
	            String substring = text.substring(pointer, pointer + k);
	            String searchWindow = text.substring(0, pointer + k - 1);
	
	            if ( searchWindow.contains(substring) ) {
	                k += 1;
	            } else {
	                pointer += k;
	                k = 0;
	                break;
	            }
	        }
	
	        if ( pointer + k > text.length() ) {
	            pointer = text.length();
	        }
	    }
	
	    return complexity;
	}

}
