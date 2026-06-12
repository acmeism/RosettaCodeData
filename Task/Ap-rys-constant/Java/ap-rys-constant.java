import java.math.BigDecimal;
import java.math.BigInteger;
import java.math.MathContext;
import java.math.RoundingMode;
import java.util.HashMap;
import java.util.Map;

public final class AperysConstant {

	public static void main(String[] args) {
		System.out.println("Apéry's constant = ζ(3), truncated to 100 digits");
		System.out.println();
		apéry(1_000);
		markov(158);
		wedeniwski(20);
		System.out.println("True value: 1.20205690315959428539973816151144999" +
			"07649862923404988817922715553418382057863130901864558736093352581");		
	}
	
	private static void apéry(int termCount) {
		BigRational sum = BigRational.ZERO;
		for ( int k = 1; k <= termCount; k++ ) {
			sum = sum.add( new BigRational(BigInteger.ONE, BigInteger.valueOf(k * k * k)) );
		}
		System.out.println("Sum cubes : " + sum.truncate(100));
	}
	
	private static void markov(int termCount) {
		final BigInteger terms = BigInteger.valueOf(termCount);
	    BigInteger sign = BigInteger.ONE.negate();
	    BigRational sum = BigRational.ZERO;
	    for ( BigInteger k = BigInteger.ONE; k.compareTo(terms) <= 0; k = k.add(BigInteger.ONE) ) {
	        sign = sign.negate();
	        BigInteger numerator = sign.multiply(factorial(k).pow(2));
	        BigInteger denominator = factorial(BigInteger.TWO.multiply(k)).multiply(k.pow(3));
	        sum = sum.add( new BigRational(numerator, denominator) );	
	    }
	    sum = sum.multiply( new BigRational(BigInteger.valueOf(5), BigInteger.TWO) );
	    System.out.println("Markov    : " + sum.truncate(100));
	}
	
	private static void wedeniwski(int termCount) {
		final BigInteger terms = BigInteger.valueOf(termCount);
	    BigInteger sign = BigInteger.ONE.negate();
	    BigRational sum = BigRational.ZERO;
	    for ( BigInteger k = BigInteger.ZERO; k.compareTo(terms) < 0; k = k.add(BigInteger.ONE) ) {
	        sign = sign.negate();	
	        BigInteger numerator = sign.multiply(factorial(BigInteger.TWO.multiply(k).add(BigInteger.ONE))
	        	.multiply(factorial(BigInteger.TWO.multiply(k))).multiply(factorial(k)).pow(3));
	        BigInteger term = ((((BigInteger.valueOf(126392).multiply(k)
	        	.add(BigInteger.valueOf(412708))).multiply(k)
	        	.add(BigInteger.valueOf(531578))).multiply(k)
	        	.add(BigInteger.valueOf(336367))).multiply(k)
	        	.add(BigInteger.valueOf(104000))).multiply(k)
	        	.add(BigInteger.valueOf(12463));	        		
	        numerator = numerator.multiply(term);
	        BigInteger denominator = factorial(BigInteger.valueOf(3).multiply(k).add(BigInteger.TWO))
	        	.multiply(factorial(BigInteger.valueOf(4).multiply(k).add(BigInteger.valueOf(3))).pow(3));
	        sum = sum.add( new BigRational(numerator, denominator) );
	    }
	    sum = sum.multiply( new BigRational(BigInteger.ONE, BigInteger.valueOf(24)) );
	    System.out.println("Wedeniwski: " + sum.truncate(100));
	}
	
	private static BigInteger factorial(BigInteger n) {
		if ( ! cache.containsKey(n) ) {
			return n.multiply(factorial(n.subtract(BigInteger.ONE)));
		}
		return cache.get(n);
	}
	
	private static Map<BigInteger, BigInteger> cache =
		new HashMap<BigInteger, BigInteger>(Map.of( BigInteger.ZERO, BigInteger.ONE ));

}

final class BigRational {
	
	public BigRational(BigInteger aNumerator, BigInteger aDenominator) {
		numerator = aNumerator;
		denominator = aDenominator;
		
    	BigInteger gcd = numerator.gcd(denominator);	    	
    	numerator = numerator.divide(gcd);
    	denominator = denominator.divide(gcd);
    }
	
	public BigRational add(BigRational other) {
		BigInteger numer = numerator.multiply(other.denominator).add(denominator.multiply(other.numerator));
		BigInteger denom = denominator.multiply(other.denominator);		
		return new BigRational(numer, denom);
	}	

	public BigRational multiply(BigRational other) {
		return new BigRational(numerator.multiply(other.numerator), denominator.multiply(other.denominator));
	}
	
	public BigDecimal truncate(int decimalPlaces) {
		BigDecimal numer = new BigDecimal(numerator);
		BigDecimal denom = new BigDecimal(denominator);
		return numer.divide(denom, new MathContext(decimalPlaces + 1, RoundingMode.FLOOR));
	}	
	
	public static final BigRational ZERO = new BigRational(BigInteger.ZERO, BigInteger.ONE);
	
	private BigInteger numerator;
	private BigInteger denominator;
	
}
