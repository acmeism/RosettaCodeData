import java.math.BigInteger;
import java.text.NumberFormat;
import java.util.ArrayList;
import java.util.List;
import java.util.Locale;

public final class MotzkinNumbers {

	public static void main(String[] aArgs) {
		final int count = 42;
		List<BigInteger> motzkins = motzkinNumbers(count);
		
		NumberFormat ukNumberFormat = NumberFormat.getInstance(Locale.UK);
		
	    System.out.println(" n        Motzkin[n]");
	    System.out.println("-----------------------------");
	
	    for ( int n = 0; n < count; n++ ) {
	    	BigInteger motzkin = motzkins.get(n);
	    	boolean prime = motzkin.isProbablePrime(PROBABILITY);
	    	System.out.print(String.format("%2d %23s", n, ukNumberFormat.format(motzkin)));	    	
	    	System.out.println( prime ? " prime" : "" );	
	    }
	}
	
	private static List<BigInteger> motzkinNumbers(int aSize) {
		List<BigInteger> result = new ArrayList<BigInteger>(aSize);
		result.add(BigInteger.ONE);
		result.add(BigInteger.ONE);
		for ( int i = 2; i < aSize; i++ ) {
			BigInteger nextMotzkin = result.get(i -  1).multiply(BigInteger.valueOf(2 * i + 1))
				.add(result.get(i - 2).multiply(BigInteger.valueOf(3 * i - 3)))
				.divide(BigInteger.valueOf(i + 2));
			
			result.add(nextMotzkin);
		}

		return result;		
	}
	
	private static final int PROBABILITY = 20;

}
