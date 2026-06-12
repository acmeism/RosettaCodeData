import module java.base;

public final class PunchedCards {

	public static void main() {
		initialiseHollerithCodes();
		
		IO.println(createPunchedCard("&-0123456789ABCDEFGHIJKLMNOPQR/STUVWXYZ:#@'=\"[.<(+|]$*);^\\,%_>?"));
		IO.println(createPunchedCard("IO.println(\"Hello World\");"));
	}
	
	// Create a punched card representation of the given text, using Hollerith codes
	private static PunchedCard createPunchedCard(String text) {
		List<List<Character>> matrix = IntStream.range(0, PUNCHED_CARD_NROWS).boxed()
			.map( i -> new ArrayList<Character>(Collections.nCopies(PUNCHED_CARD_NCOLS, ' ')) )
			.collect(Collectors.toList());

	    matrix.get(0).set(0, '/'); // Upper left corner
	    matrix.get(0).set(PUNCHED_CARD_NCOLS - 1, '+'); // Upper right corner
	    matrix.get(PUNCHED_CARD_NROWS - 1).set(0, '+'); // Lower left corner
	    matrix.get(PUNCHED_CARD_NROWS - 1).set(PUNCHED_CARD_NCOLS - 1, '+'); // Lower right corner
	    for ( int col = 1; col < PUNCHED_CARD_NCOLS - 1; col++ ) { // Upper and lower borders
	    	matrix.get(0).set(col, '-');
	    	matrix.get(PUNCHED_CARD_NROWS - 1).set(col, '-');
	    }
	    for ( int row = 1; row < PUNCHED_CARD_NROWS - 1; row++ ) { // Left and right borders
	    	matrix.get(row).set(0, '|');
	    	matrix.get(row).set(PUNCHED_CARD_NCOLS - 1, '|');
	    }
	    for ( int n = 0; n <= 9; n++ ) { // Row labels for punches 0..9
	    	for ( int row = n + 4; row < PUNCHED_CARD_NROWS - 2; row++ ) {
	    		for ( int col = 2; col < PUNCHED_CARD_NCOLS - 2; col++ ) {
	    			matrix.get(row).set(col, Character.forDigit(n, 10));
	    		}
	    	}
	    }
		
		for ( int i = 0; i < text.length(); i++ ) {
			final char ch = text.charAt(i);
	        final int col = i + 2; // Skip the left border
	
	        matrix.get(PUNCHED_CARD_TEXT_ROW).set(col, ch); // Print text character in row 1
	        int punch = hollerithCodes.get(Integer.valueOf(ch + 1));
	        while ( punch > 0 ) {
	        	final int remainder = punch % 16;
	        	punch /= 16;
	            if ( remainder > 9 ) {
	            	matrix.get(2 + 12 - remainder).set(col, PUNCHED_CHAR); // Rows 11 and 12
	            } else {
	                matrix.get(4 + remainder).set(col, PUNCHED_CHAR); // Rows 0..9
	            }
	        }
	    }

		return new PunchedCard(text, matrix);
	}
	
	private static void initialiseHollerithCodes() {
		// Digits
		for ( char digit = '0'; digit <= '9'; digit++ ) {
			final int value = ( digit == '0' ) ? 10 : digit - '0';
			hollerithCodes.put(digit + 1, value);
		}
		// Upper case letters
	    for ( char letter = 'A'; letter <= 'I'; letter++ ) {
	        hollerithCodes.put(letter + 1, 0xc0 | letter - 'A' + 1);
	    }
	    for ( char letter = 'J'; letter <= 'R'; letter++ ) {
	    	hollerithCodes.put(letter + 1, 0xb0 | letter - 'J' + 1);
	    }
	    for ( char letter = 'S'; letter <= 'Z'; letter++ ) {
	    	hollerithCodes.put(letter + 1, 0xa0 | letter - 'S' + 2);
	    }	
	    // Lower case letters
	    for ( char letter = 'a'; letter <= 'i'; letter++ ) {
	        hollerithCodes.put(letter + 1, 0xca0 | letter - 'a' + 1);
	    }
	    for ( char letter = 'j'; letter <= 'r'; letter++ ) {
	        hollerithCodes.put(letter + 1, 0xcb0 | letter - 'j' + 1);
	    }
	    for ( char letter = 's'; letter <= 'z'; letter++ ) {
	        hollerithCodes.put(letter + 1, 0xba0 | letter - 's' + 2);
	    }
	    // Special characters
	    List.of( new Pair('&', 0x00c), new Pair('-', 0x00b), new Pair('[', 0x28c), new Pair('.', 0x38c),
	    		 new Pair('<', 0x48c), new Pair('(', 0x58c), new Pair('+', 0x68c), new Pair('!', 0x78c),
	    		 new Pair(']', 0x28b), new Pair('$', 0x38b), new Pair('*', 0x48b), new Pair(')', 0x58b),
	    		 new Pair(';', 0x68b), new Pair('^', 0x78b), new Pair('\\', 0x28a), new Pair(',', 0x38a),
	    		 new Pair('%', 0x48a), new Pair('_', 0x58a), new Pair('>', 0x68a), new Pair('?', 0x78a),
	    		 new Pair('/', 0x01a), new Pair('`', 0x018), new Pair(':', 0x028), new Pair('#', 0x038),
	    		 new Pair('@', 0x048), new Pair('\'', 0x058), new Pair('=', 0x068), new Pair('"', 0x078),
	    		 new Pair('|', 0x0cb), new Pair('{', 0x0ca), new Pair('}', 0x0ba), new Pair(' ', 0x000)
	    ).forEach( pair -> hollerithCodes.put(pair.synbol + 1, pair.value) );
	}

	private static record Pair(Character synbol, int value) {}
	
	private static record PunchedCard(String text, List<List<Character>> matrix) {
		
		public String toString() {
			StringBuilder builder = new StringBuilder();
			for ( int row = 0; row < matrix.size(); row++ ) {
				for ( int col = 0; col < matrix.getFirst().size(); col++ ) {
					builder.append(matrix.get(row).get(col));
				}
				builder.append(System.lineSeparator());
			}
			return builder.toString();
		}		
		
	}
	
	private static Map<Integer, Integer> hollerithCodes = new HashMap<Integer, Integer>();
	
	private static final char PUNCHED_CHAR = '█'; // unicode /u2588, used to represent punched holes in the card
	private static final int PUNCHED_CARD_NCOLS = 84;
	private static final int PUNCHED_CARD_NROWS = 16;
	private static final int PUNCHED_CARD_TEXT_ROW = 1; // row index for text, 0-based

}
