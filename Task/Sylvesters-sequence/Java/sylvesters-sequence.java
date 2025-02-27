import java.math.BigDecimal;
import java.math.BigInteger;
import java.math.MathContext;
import java.math.RoundingMode;

public final class SylvestersSequence {

	public static void main(String[] args) {
		System.out.println("The first 10 terms in Sylvester's sequence are:");
		BigInteger term = BigInteger.TWO;
		BigRational sum = BigRational.ZERO;
	    for ( int i = 1; i <= 10; i++ ) {
	    	System.out.println(term);
	        sum = sum.add( new BigRational(BigInteger.ONE, term) );
	        term = term.multiply(term).subtract(term).add(BigInteger.ONE);
	    }
	    System.out.println();
	
	    System.out.println("The sum of their reciprocals as a rational number is:");
	    System.out.println(sum + System.lineSeparator());	
	
	    System.out.println("The sum of their reciprocals as a decimal number, to 235 decimal places, is:");
	    System.out.println(sum.toDecimal(235));
	}

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
	
	public String toDecimal(int decimalPlaces) {
		BigDecimal numer = new BigDecimal(numerator);
		BigDecimal denom = new BigDecimal(denominator);
		return numer.divide(denom, new MathContext(decimalPlaces + 1, RoundingMode.HALF_UP)).toString();
	}	
	
	public String toString() {
		return numerator.toString() + " / " + denominator.toString();
	}

	public static final BigRational ZERO = new BigRational(BigInteger.ZERO, BigInteger.ONE);
	
	private BigInteger numerator;
	private BigInteger denominator;
	
}
