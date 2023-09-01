import java.math.BigInteger;
import java.util.List;

public final class JugglerSequence {

	public static void main(String[] aArgs) {
		System.out.println(" n    l[n]  i[n]             h[n]");
		System.out.println("---------------------------------");
		for ( int number = 20; number <= 39; number++ ) {
		    JugglerData result = juggler(number);
		    System.out.println(String.format("%2d%7d%6d%17d",
		    	number, result.aCount, result.aMaxCount, result.aMaxNumber));
		}
		System.out.println();
		
		List<Integer> values = List.of( 113, 173, 193, 2183, 11229, 15065, 15845, 30817 );
		System.out.println("    n     l[n]   i[n]   d[n]");
		System.out.println("----------------------------");
		for ( int value : values ) {
		    JugglerData result = juggler(value);
		    System.out.println(String.format("%5d%8d%7d%7d",
		    	value, result.aCount, result.aMaxCount, result.aDigitCount));
		}
	}
	
	private static JugglerData juggler(int aNumber) {
		if ( aNumber < 1 ) {
			throw new IllegalArgumentException("Starting value must be >= 1: " + aNumber);
		}
	    BigInteger number = BigInteger.valueOf(aNumber);
	    int count = 0;
	    int maxCount = 0;
	    BigInteger maxNumber = number;
	    while ( ! number.equals(BigInteger.ONE) ) {
	    	number = number.testBit(0) ? number.pow(3).sqrt() : number.sqrt();
	        count = count + 1;
	        if ( number.compareTo(maxNumber) > 0 ) {
	            maxNumber = number;
	            maxCount = count;
	        }
	    }
	    return new JugglerData(count, maxCount, maxNumber, String.valueOf(maxNumber).length());
	}
	
	private static record JugglerData(int aCount, int aMaxCount, BigInteger aMaxNumber, int aDigitCount) {}

}
