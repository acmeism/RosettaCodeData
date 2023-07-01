import java.math.BigInteger;
import java.util.List;

public final class DistributionInFactorials {

	public static void main(String[] aArgs) {
		List<Integer> limits = List.of( 100, 1_000, 10_000 );
		for ( Integer limit : limits ) {
			meanFactorialDigits(limit);
		}
	}
	
	private static void meanFactorialDigits(Integer aLimit) {
		BigInteger factorial = BigInteger.ONE;
		double proportionSum = 0.0;
		double proportionMean = 0.0;
		
		for ( int n = 1; n <= aLimit; n++ ) {
	        factorial = factorial.multiply(BigInteger.valueOf(n));
	        String factorialString = factorial.toString();
	        int digitCount = factorialString.length();	
	        long zeroCount = factorialString.chars().filter( ch -> ch == '0' ).count();
	        proportionSum += (double) zeroCount / digitCount;
	        proportionMean = proportionSum / n;	
		}
		
		String result = String.format("%.8f", proportionMean);
		System.out.println("Mean proportion of zero digits in factorials from 1 to " + aLimit + " is " + result);
	}	

}
