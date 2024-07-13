import java.util.Arrays;
import java.util.List;

public final class LargestNumberDivisibleByItsDigits {

	public static void main(String[] args) {
		// Base 10
		final int decimalDivisor = 9 * 8 * 7;		
	    int decimal = ( 9876432 / decimalDivisor ) * decimalDivisor;
	
	    while ( ! isLynchBellDecimal(decimal) ) {
	    	decimal -= decimalDivisor;	
	    }	
	    System.out.println("The largest decimal Lynch-Bell number is " + decimal);
		
		// Base 16
		final long hexDivisor = 15L * 14 * 13 * 12 * 11;
		
	    long hexadecimal = ( 0xfedcba987654321L / hexDivisor ) * hexDivisor;
	    while ( ! isLynchBellHex(hexadecimal) ) {
	    	hexadecimal -= hexDivisor;
	    }
	    System.out.println("The largest hexadecimal Lynch-Bell number is " + Long.toHexString(hexadecimal));	
	}
	
	private static boolean isLynchBellDecimal(int decimal) {
		String decimalString = Integer.toString(decimal);
        if ( decimalString.contains("0") || decimalString.contains("5") ) {
        	return false;
        }

        List<Integer> distinctDigits =
    		Arrays.stream(decimalString.split("")).map( s -> Integer.valueOf(s) ).distinct().toList();	
        if ( distinctDigits.size() < decimalString.length() ) {
        	return false;
        }

        return distinctDigits.stream().allMatch( i -> ( decimal % i ) == 0 );
	}
	
	private static boolean isLynchBellHex(long hexadecimal) {
		String hexString = Long.toHexString(hexadecimal);
		if ( hexString.contains("0") ) {
			return false;
		}
		
		List<Integer> distinctDigits =
			Arrays.stream(hexString.split("")).map( s -> Integer.valueOf(s, 16) ).distinct().toList();			
		if ( distinctDigits.size() < hexString.length() ) {
			return false;
		}
		
		return distinctDigits.stream().allMatch( i -> ( hexadecimal % i ) == 0 );
	}
	
}
