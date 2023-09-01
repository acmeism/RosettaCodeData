	public static void main(String[] aArgs) {
		ownPasswordCalculationTest("12345", "603356072", 25280520);
	    ownPasswordCalculationTest("12345", "410501656", 119537670);
	}
	
	private static void ownPasswordCalculationTest(String password, String nonce, long expected) {
	    final long result = ownPasswordCalculation(Long.valueOf(password), nonce);
	    String message = password + "  " + nonce + "  " + result + "  " + expected;
	    System.out.println( ( result == expected ) ? "PASS  " + message : "FAIL  " + message );
	}
	
	private static long ownPasswordCalculation(long password, String nonce) {
	    final long m1        = 0xFFFF_FFFFL;
	    final long m8        = 0xFFFF_FFF8L;
	    final long m16       = 0xFFFF_FFF0L;
	    final long m128      = 0xFFFF_FF80L;
	    final long m16777216 = 0xFF00_0000L;

	    boolean flag = true;
	    long number1 = 0;
	    long number2 = 0;

	    for ( char ch : nonce.toCharArray() ) {
	        number2 = number2 & m1;

	        switch (ch) {
		        case '1' -> {
		            if ( flag ) { number2 = password; }
	                flag = false;
	                number1 = number2 & m128;
	                number1 = number1 >>> 7;
	                number2 = number2 << 25;
	                number1 = number1 + number2;
		        }
	
		        case '2' -> {
		            if ( flag ) { number2 = password; }
	                flag = false;
	                number1 = number2 & m16;
	                number1 = number1 >>> 4;
	                number2 = number2 << 28;
	                number1 = number1 + number2;
	            }
	
		        case '3' -> {
		            if ( flag ) { number2 = password; }
	                flag = false;
	                number1 = number2 & m8;
	                number1 = number1 >>> 3;
	                number2 = number2 << 29;
	                number1 = number1 + number2;
	            }
	
		        case '4' -> {
		        	if ( flag ) { number2 = password; }
	                flag = false;
	                number1 = number2 << 1;
	                number2 = number2 >>> 31;
	                number1 = number1 + number2;
	            }
	
		        case '5' -> {
		            if ( flag ) { number2 = password; }
	                flag = false;
	                number1 = number2 << 5;
	                number2 = number2 >>> 27;
	                number1 = number1 + number2;
	            }
	
		        case '6' -> {
		            if ( flag ) { number2 = password; }
	                flag = false;
	                number1 = number2 << 12;
	                number2 = number2 >>> 20;
	                number1 = number1 + number2;
	            }
	
		        case '7' -> {
		            if ( flag ) { number2 = password; }
	                flag = false;
	                number1 = number2 & 0xFF00L;
	                number1 = number1 + ( ( number2 & 0xFFL ) << 24 );
	                number1 = number1 + ( ( number2 & 0xFF0000L ) >>> 16 );
	                number2 = ( number2 & m16777216 ) >>> 8;
	                number1 = number1 + number2;
	            }
	
		        case '8' -> {
		            if ( flag ) { number2 = password;}
	                flag = false;
	                number1 = number2 & 0xFFFFL;
	                number1 = number1 << 16;
	                number1 = number1 + ( number2 >>> 24 );
	                number2 = number2 & 0xFF0000L;
	                number2 = number2 >>> 8;
	                number1 = number1 + number2;
	            }
	
		        case '9' -> {
		            if ( flag ) { number2 = password; }
	                flag = false;
	                number1 = ~number2;
	            }
		
		        default -> number1 = number2;
	        }
	        number2 = number1;
	    }
	
	    return number1 & m1;
	}

}
