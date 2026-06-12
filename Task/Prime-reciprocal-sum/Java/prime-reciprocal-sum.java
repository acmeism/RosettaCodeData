import java.math.BigInteger;

public final class PrimeReciprocalSum {

	public static void main(String[] args) {
		BigRational sum = BigRational.ZERO;
		int count = 0;
		
		while ( count < 15 ) {
			BigInteger minimumValue = BigRational.ONE.subtract(sum).inverse().ceiling();
			BigInteger prime = minimumValue.nextProbablePrime();			
			sum = sum.add( new BigRational(BigInteger.ONE, prime) );
			count += 1;
			System.out.println(String.format("%2s%s%s", count, ": ", compress(prime, 20)));
		}
	}
	
	private static String compress(BigInteger number, int size) {
		String digits = number.toString();
		final int length = digits.length();
		if ( length <= 2 * size )  {
			return digits;
		}		
		return digits.substring(0, size) + " ... "
			+ digits.substring(length - size) + " (" + length + " digits)";
	}

}

final class BigRational {
	
	public BigRational(BigInteger aNumer, BigInteger aDenom) {
		numer = aNumer;
		denom = aDenom;
		
    	BigInteger gcd = numer.gcd(denom);	    	
    	numer = numer.divide(gcd);
    	denom = denom.divide(gcd);
    }

	public BigRational add(BigRational other) {
		BigInteger num = numer.multiply(other.denom).add(other.numer.multiply(denom));
		BigInteger den = denom.multiply(other.denom);			
		return new BigRational(num, den);
	}
	
	public BigRational subtract(BigRational other) {
		BigInteger num = numer.multiply(other.denom).subtract(denom.multiply(other.numer));
		BigInteger den = denom.multiply(other.denom);
		return new BigRational(num, den);
	}

	public BigRational inverse() {
		return new BigRational(denom, numer);
	}
	
	public BigInteger ceiling() {
		BigInteger[] pair = numer.divideAndRemainder(denom);
		return pair[1].equals(BigInteger.ZERO) ? pair[0] : pair[0].add(BigInteger.ONE);
	}	

	public static final BigRational ZERO = new BigRational(BigInteger.ZERO, BigInteger.ONE);
	public static final BigRational ONE = new BigRational(BigInteger.ONE, BigInteger.ONE);
		
	private BigInteger numer;
	private BigInteger denom;
	
}
