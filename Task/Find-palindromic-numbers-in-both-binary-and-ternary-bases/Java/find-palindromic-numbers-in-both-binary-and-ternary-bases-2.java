public final class FindPalindromicNumbersBases23 {

	public static void main(String[] aArgs) {		
	    System.out.println("The first 7 numbers which are palindromic in both binary and ternary are:");
	    display(0); // 0 is a palindrome in all 3 bases
	    display(1); // 1 is a palindrome in all 3 bases
	
	    long number = 1;
	    int count = 2;
	    do {
	        long ternary = createTernaryPalindrome(number);
	        if ( ternary % 2 == 1 )  { // Cannot be an even number since its binary equivalent would end in zero
	            String binary = toBinaryString(ternary);
	            if ( binary.length() % 2 == 1 ) { // Binary palindrome must have an odd number of digits
	                if ( isPalindromic(binary) ) {
	                    display(ternary);
	                    count++;
	                }
	            }
	        }
	        number++;
	    }
	    while ( count < 7 );
	}
	
	// Create a ternary palindrome whose left part is the ternary equivalent of the given number
	// and return its decimal equivalent
	private static long createTernaryPalindrome(long aNumber) {
	    String ternary = toTernaryString(aNumber);
	    long powerOf3 = 1;
	    long sum = 0;
	    for ( int i = 0; i < ternary.length(); i++ ) { // Right part of a palindrome is the mirror image of left part
	        if ( ternary.charAt(i) > '0' ) {
	        	sum += ( ternary.charAt(i) - '0' ) * powerOf3;
	        }
	        powerOf3 *= 3;
	    }
	    sum += powerOf3; // Middle digit must be 1
	    powerOf3 *= 3;
	    sum += aNumber * powerOf3; // Left part is the given number multiplied by the appropriate power of 3
	    return sum;
	}
	
	private static boolean isPalindromic(String aNumber) {
		return aNumber.equals( new StringBuilder(aNumber).reverse().toString() );
	}
	
	private static String toTernaryString(long aNumber) {
	    if ( aNumber == 0 ) {
	    	return "0";
	    }
	
	    StringBuilder result = new StringBuilder();
	    while ( aNumber > 0 ) {
	        result.append(aNumber % 3);
	        aNumber /= 3;
	    }
	    return result.reverse().toString();
	}
	
	private static String toBinaryString(long aNumber) {
		return Long.toBinaryString(aNumber);
	}
	
	private static void display(long aNumber) {
		System.out.println("Decimal: " + aNumber);
		System.out.println("Binary : " + toBinaryString(aNumber));		
		System.out.println("Ternary: " + toTernaryString(aNumber));
		System.out.println();
	}

}
