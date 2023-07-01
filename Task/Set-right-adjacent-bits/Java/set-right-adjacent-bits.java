public final class SetRightAdjacentBits {

	public static void main(String[] aArgs) {
		setRightAdjacent("1000", 2);
		setRightAdjacent("0100", 2);
		setRightAdjacent("0010", 2);
		setRightAdjacent("0000", 2);
		
		String test = "010000000000100000000010000000010000000100000010000010000100010010";
		setRightAdjacent(test, 0);
		setRightAdjacent(test, 1);
		setRightAdjacent(test, 2);
		setRightAdjacent(test, 3);
	}	
	
	private static void setRightAdjacent(String aText, int aNumber) {
		System.out.println("n = " + aNumber + ", Width = " + aText.length() + ", Input: " + aText);	
		
		char[] text = aText.toCharArray();
		char[] result = aText.toCharArray();
	    for ( int i = 0; i < result.length; i++ ) {
	    	if ( text[i] == '1' ) {	    		
	    		for ( int j = i + 1; j <= i + aNumber && j < result.length; j++ ) {
	    			result[j] = '1';
	    		}
	    	}
	    }
	
	    String spaces = " ".repeat(16 + String.valueOf(aText.length()).length());
		System.out.println(spaces + "Result: " + new String(result) + System.lineSeparator());
	}

}
