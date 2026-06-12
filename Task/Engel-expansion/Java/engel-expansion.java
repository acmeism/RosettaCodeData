import java.math.BigDecimal;
import java.math.BigInteger;
import java.math.MathContext;
import java.math.RoundingMode;
import java.util.ArrayList;
import java.util.List;

public final class EngelExpansion {

	public static void main(String[] args) {
		List<String> rationals = List.of( "3.14159265358979", "2.71828182845904", "1.414213562373095",
				
			"3.141592653589793238462643383279502884197169399375105820974944592307816406286208998628034"
		    + "8253421170679821480865132823066470938446095505822317253594081284811174502841027019385211",
			
		    "2.718281828459045235360287471352662497757247093699959574966967627724076630353547594571382"
		    + "17852516642743",
			
		    "1.414213562373095048801688724209698078569671875376948073176679737990732478462107038850387534"
		    + "3276415727350138462309122970249248360558507372126441214970999358314132226659275055927558" );
		
		for ( String rational : rationals ) {			
			List<BigInteger> engel = toEngel(rational);
			System.out.println("Rational number : " + rational);
			System.out.println("Engel expansion : " + engel.stream().limit(30).toList());
			System.out.println("Number of terms : " + engel.size());
			final int decimalPlaces = rational.length() - rational.indexOf(".") - 1;
			System.out.println("Back to rational: " +
				fromEngel(engel.stream().limit(70).toList()).toDecimal(decimalPlaces));
			System.out.println();
		}
	}

	private static List<BigInteger> toEngel(String decimal) {
	    List<BigInteger> engel = new ArrayList<BigInteger>();
	    BigRational rational = new BigRational(decimal);
	    while ( ! rational.equals(BigRational.ZERO) ) {
	        BigInteger term = rational.inverse().ceiling();
	        engel.addLast(term);
	        rational = rational.multiply( new BigRational(term) ).subtract(BigRational.ONE);
	    }
	    return engel;
	}
	
	private static BigRational fromEngel(List<BigInteger> engel) {
	    BigRational sum = BigRational.ZERO;
	    BigRational product = BigRational.ONE;
	    for ( BigInteger element : engel ) {
	        BigRational rational = new BigRational(element).inverse();
	        product = product.multiply(rational);
	        sum = sum.add(product);
	    }
	    return sum;
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
	
	public BigRational(BigInteger value) {
		numerator = value;
		denominator = BigInteger.ONE;
	}	
	
	public BigRational(String decimal) {
		final int index = decimal.indexOf(".");
		final int decimalPlaces = decimal.length() - index - 1;
		BigInteger numer = new BigInteger(decimal.substring(0, index) + decimal.substring(index + 1));
		BigInteger denom = BigInteger.TEN.pow(decimalPlaces);
		this(numer, denom);
	}
	
	public String toDecimal(int decimalPlaces) {
		BigDecimal numer = new BigDecimal(numerator);
		BigDecimal denom = new BigDecimal(denominator);
		return numer.divide(denom, new MathContext(decimalPlaces + 1, RoundingMode.HALF_UP)).toString();
	}	
	
	public boolean equals(BigRational other) {
		return numerator.equals(other.numerator) && denominator.equals(other.denominator);
	}
	
	public BigRational add(BigRational other) {
		BigInteger numer = numerator.multiply(other.denominator).add(denominator.multiply(other.numerator));
		BigInteger denom = denominator.multiply(other.denominator);		
		return new BigRational(numer, denom);
	}	
	
	public BigRational subtract(BigRational other) {
		BigInteger numer =
			numerator.multiply(other.denominator).subtract(denominator.multiply(other.numerator));
		BigInteger denom = denominator.multiply(other.denominator);
		return new BigRational(numer, denom);
	}
	
	public BigRational multiply(BigRational other) {
		return new BigRational(numerator.multiply(other.numerator), denominator.multiply(other.denominator));
	}
	
	public BigRational inverse() {
		return new BigRational(denominator, numerator);
	}
	
	public BigInteger ceiling() {
		BigInteger[] pair = numerator.divideAndRemainder(denominator);
		return pair[1].equals(BigInteger.ZERO) ? pair[0] : pair[0].add(BigInteger.ONE);
	}
		
	public static final BigRational ZERO = new BigRational(BigInteger.ZERO, BigInteger.ONE);
	public static final BigRational ONE = new BigRational(BigInteger.ONE, BigInteger.ONE);
	
	private BigInteger numerator;
	private BigInteger denominator;
	
}
