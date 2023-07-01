import java.math.BigInteger;

public class HarmonicSeries {
	
	public static void main(String[] aArgs) {
		
		System.out.println("The first twenty Harmonic numbers:");
		for ( int i = 1; i <= 20; i++ ) {
			System.out.println(String.format("%2s", i) + ": " + harmonicNumber(i));
		}		
		
		System.out.println();
		for ( int i = 1; i <= 10; i++ ) {
			System.out.print("The first term greater than ");
			System.out.println(String.format("%2s%s%5s", i, " is Term ", indexedHarmonic(i)));
		}

	}

    private static Rational harmonicNumber(int aNumber) {
		Rational result = Rational.ZERO;
		for ( int i = 1; i <= aNumber; i++ ) {
			result = result.add( new Rational(BigInteger.ONE, BigInteger.valueOf(i)) );
		}
		
		return result;
	}
	
	private static int indexedHarmonic(int aTarget) {
		BigInteger target = BigInteger.valueOf(aTarget);
		Rational harmonic = Rational.ZERO;
		BigInteger next = BigInteger.ZERO;
		
		while ( harmonic.numerator.compareTo(target.multiply(harmonic.denominator)) <= 0 ) {
			next = next.add(BigInteger.ONE);
			harmonic = harmonic.add( new Rational(BigInteger.ONE, next) );						
		}
		
		return next.intValueExact();
	}	
	
	private static class Rational {
		
		private Rational(BigInteger aNumerator, BigInteger aDenominator) {
			numerator = aNumerator;
			denominator = aDenominator;
			
	    	BigInteger gcd = numerator.gcd(denominator);	    	
	    	numerator = numerator.divide(gcd);
	    	denominator = denominator.divide(gcd);
	    }
		
		@Override
		public String toString() {
			return numerator + " / " + denominator;
		}
		
		private Rational add(Rational aRational) {
			BigInteger numer = numerator.multiply(aRational.denominator)
                .add(aRational.numerator.multiply(denominator));
			BigInteger denom = aRational.denominator.multiply(denominator);
			
			return new Rational(numer, denom);
		}	
		
		private BigInteger numerator;
		private BigInteger denominator;
		
		private static final Rational ZERO = new Rational(BigInteger.ZERO, BigInteger.ONE);
		
	}

}
