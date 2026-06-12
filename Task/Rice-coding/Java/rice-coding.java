import java.util.stream.IntStream;

public final class RiceCoding {

	public static void main(String[] args) {
		System.out.println("Base Rice Coding with k = 2:");
	    IntStream.rangeClosed(0, 10).forEach( n -> {
	        String encoded = Rice.encode(n, 2, Type.STANDARD);
	        System.out.println(n + " -> " + encoded + " -> " + Rice.decode(encoded, 2, Type.STANDARD));
	    } );
	    System.out.println();
	
	    System.out.println("Extended Rice Coding with k = 2:");
	    IntStream.rangeClosed(-10, 10).forEach( n -> {
	        String encoded = Rice.encode(n, 2, Type.EXTENDED);
	        System.out.println(n + " -> " + encoded + " -> " + Rice.decode(encoded, 2, Type.EXTENDED));
	    } );
	    System.out.println();
	
	    System.out.println("Base Rice Coding with k = 4:");
	    IntStream.rangeClosed(0, 17).forEach( n -> {
	        String encoded = Rice.encode(n, 4, Type.STANDARD);
	        System.out.println(n + " -> " + encoded + " -> " + Rice.decode(encoded, 4, Type.STANDARD));
	    } );
	}
	
}

enum Type { STANDARD, EXTENDED }

final class Rice {
	
	public static String encode(int n, int k, Type type) {
		int value = n;	
		if ( type == Type.EXTENDED ) {
			value = ( value < 0 ) ? -value * 2 - 1 : 2 * value;
		}
	
		if ( value < 0 ) {
			throw new IllegalArgumentException("n cannot be negative: " + n);
		}		

        final int m = 1 << k;
        final int quotient = value / m;
        final int remainder = value % m;
        String ones = "1".repeat(quotient);
        String binary = Integer.toBinaryString(remainder);
        String remainderBinary = "0".repeat(k + 1 - binary.length()) + binary;

        return ones + remainderBinary;
    }
	
	public static int decode(String encoded, int k, Type type) {
	    final int m = 1 << k;
	    final int quotient = Math.max(0, encoded.indexOf('0'));
	    final int remainder = Integer.parseInt(encoded.substring(quotient), 2);
	    int result = quotient * m + remainder;
	
	    if ( type == Type.EXTENDED ) {
	        result = ( result % 2 == 1 ) ? -( ( result + 1 ) / 2 ) : result / 2;
	    }	
	    return result;	
	}	
	
}
