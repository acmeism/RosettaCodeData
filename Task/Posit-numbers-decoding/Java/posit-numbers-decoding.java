import module java.base;

public final class PositNumbersDecoding {

	public static void main() {
		List<Posit> posits = List.of(
            new Posit(3, "0000110111011101"),
            new Posit(3, "1000000000000000"),
			new Posit(3, "0000000000000000"),
			new Posit(1, "0110110010101000"),
			new Posit(1, "1001001101011000"),			
			new Posit(2, "0000000000000001"),
			new Posit(0, "0111111111111111"),
			new Posit(6, "0111111111111110"),
			new Posit(1, "01000000"),
			new Posit(1, "11000000"),
			new Posit(1, "00110000"),
			new Posit(1, "00100000"),
			new Posit(2, "00000001"),
			new Posit(2, "01111111"),
			new Posit(7, "01111110"),
			new Posit(2, "00000000000000000000000000000001"),
			new Posit(2, "01111111111111111111111111111111"),
			new Posit(5, "01111111111111111111111111111110")			
         );
		
		posits.forEach( posit -> {
			BigRational result = positDecode(posit);
			IO.println(posit + " => " + result + " or " + result.toDouble());
		} );
	}
	
	private static BigRational positDecode(Posit posit) {
		// Deal with the exceptional values: zero and infinity
		if ( IntStream.range(1, posit.binary.length()).allMatch( i -> posit.binary.charAt(i) == '0' ) ) {
			 return ( posit.binary.charAt(0) == '0' ) ? BigRational.ZERO : BigRational.INFINITY;
		}

		// If 'posit.binary' represents a negative number, convert the non-sign digits into twos-complement
		List<Integer> digits;
		if ( posit.binary.charAt(0) == '0' ) {
			digits = posit.binary.chars().map( i -> (char) i == '0' ? 0 : 1 ).boxed().collect(Collectors.toList());
		} else {
			final int number = Integer.parseInt(posit.binary, 2);
	    	String complement = "1" + Integer.toBinaryString(-number).substring(32 - posit.binary.length() + 1);
			digits = complement.chars().map( i -> (char) i == '0' ? 0 : 1 ).boxed().collect(Collectors.toList());
		}

	    // Determine the regime
	    final int first = digits.get(1);
	    int index = 2;
	    while ( index < digits.size() && digits.get(index) == first ) {
	    	index += 1;
	    }
	    final int regimeSize = index - 1;
	    List<Integer> regime = digits.subList(1, regimeSize + 1);
	
	    // Complete the calculation
	    final int exponentSize = ( regimeSize == digits.size() - 1 ) ?
	    	0 : Math.min(posit.es, digits.size() - 2 - regimeSize);
	    List<Integer> exponent = ( exponentSize > 0 ) ?
	    	digits.subList(regimeSize + 2, regimeSize + 2  + exponentSize) : List.of( 0 );
	    final int functionSize = ( exponentSize == 0 ) ? 0 : digits.size() - 2 - regimeSize - exponentSize;	
	    final int k = regime.stream().allMatch( i -> i == 0 ) ? -regimeSize : regimeSize - 1;
	    final int e = Integer.parseInt(
	    	exponent.stream().map(String::valueOf).collect(Collectors.joining("")), 2);
	    final BigInteger sign = ( digits.getFirst() == 0 ) ? BigInteger.ONE : BigInteger.ONE.negate();	
	    final BigInteger u = BigInteger.TWO.pow((int) Math.powExact(2, posit.es));
	
	    BigRational f = BigRational.ONE;	
	    if ( functionSize > 0 ) {
	        String fraction = digits.subList(digits.size() - functionSize, digits.size())
	        	.stream().map(String::valueOf).collect(Collectors.joining(""));
	        f = new BigRational(BigInteger.valueOf(Integer.parseInt(fraction, 2)), BigInteger.ONE);
	        f = BigRational.ONE.add( new BigRational(f, BigInteger.valueOf((int) Math.powExact(2, functionSize))) );
	    }	
	
	    return f.multiply( new BigRational(u, BigInteger.ONE).power(k) )
	    	.multiply( new BigRational(BigInteger.TWO.pow(e).multiply(sign), BigInteger.ONE) );
	}
	
	private record Posit(int es, String binary) {
		
		public String toString() {
			return "(" + es + ", " + binary + ")";
		}
		
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
	
	public BigRational(BigRational aRational, BigInteger aDenominator) {
		this(aRational.numerator, aDenominator.multiply(aRational.denominator));
	}
	
	public BigRational add(BigRational other) {
		BigInteger numer = numerator.multiply(other.denominator).add(denominator.multiply(other.numerator));
		BigInteger denom = denominator.multiply(other.denominator);		
		return new BigRational(numer, denom);
	}		
	
	public BigRational multiply(BigRational other) {
		return new BigRational(numerator.multiply(other.numerator), denominator.multiply(other.denominator));
	}
	
	public BigRational power(int exponent) {
		return ( exponent >= 0 ) ? new BigRational(numerator.pow(exponent), denominator.pow(exponent))
			: new BigRational(denominator.pow(-exponent), numerator.pow(-exponent));
	}
	
	public double toDouble() {
		return numerator.doubleValue() / denominator.doubleValue();
	}
	
	public String toString() {
		return ( denominator.signum() == 0 ) ? "∞" : numerator + " / " + denominator;
	}
	
	public static final BigRational ZERO = new BigRational(BigInteger.ZERO, BigInteger.ONE);
	public static final BigRational ONE = new BigRational(BigInteger.ONE, BigInteger.ONE);
	public static final BigRational INFINITY = new BigRational(BigInteger.ONE, BigInteger.ZERO);
	
	private BigInteger numerator;
	private BigInteger denominator;
	
}
