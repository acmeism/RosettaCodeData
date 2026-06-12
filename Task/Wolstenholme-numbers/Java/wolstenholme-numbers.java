import java.math.BigInteger;
import java.util.ArrayList;
import java.util.List;

public final class WolstenholmeNumbers {

	public static void main(String[] args) {
		WolstenholmeIterator iterator = new WolstenholmeIterator();
		List<BigInteger> wolstenholmePrimes = new ArrayList<BigInteger>();
		
		System.out.println("Wolstenholme numbers:");
		for ( int index = 1; index <= 10_000; index++ ) {
			BigInteger wolstenholmeNumber = iterator.next();
			
			if ( wolstenholmePrimes.size() < 15 && wolstenholmeNumber.isProbablePrime(15) ) {
				wolstenholmePrimes.add(wolstenholmeNumber);
			}
			
			if ( index <= 20 || PRINT_POINTS.contains(index) ) {
				System.out.println(String.format("%5d%s%s", index, ": ", abbreviate(wolstenholmeNumber)));
			}			
		}
		
		System.out.println();
		System.out.println("Prime Wolstenholme numbers:");
		for ( int index = 0; index < wolstenholmePrimes.size(); index++ ) {
			System.out.println(String.format("%5d%s%s", index + 1, ": ", abbreviate(wolstenholmePrimes.get(index))));
		}
	}
	
	private static String abbreviate(BigInteger number) {
		String text = number.toString();
		int digits = text.length();
		return digits <= 20 ?
			text : text.substring(0, 20) + " ... " + text.substring(digits - 20) + " (digits: " + digits + ")";
	}
	
	private static final List<Integer> PRINT_POINTS = List.of( 500, 1_000, 2_500, 5_000, 10_000 );
	
}

final class WolstenholmeIterator {
	
	public BigInteger next() {
		BigInteger result = secondHarmonic.numerator();
		k += 1;
		secondHarmonic = secondHarmonic.add( new Rational(BigInteger.ONE, BigInteger.valueOf(k * k)) );
		return result;
	}
	
	private int k = 1;	
	private Rational secondHarmonic = new Rational(BigInteger.ONE, BigInteger.ONE);
	
}

final class Rational {
	
	public Rational(BigInteger aNumerator, BigInteger aDenominator) {
		numerator = aNumerator;
		denominator = aDenominator;
		
    	BigInteger gcd = numerator.gcd(denominator);	    	
    	numerator = numerator.divide(gcd);
    	denominator = denominator.divide(gcd);
    }
	
	public Rational add(Rational aRational) {
		BigInteger numer = numerator.multiply(aRational.denominator).add(aRational.numerator.multiply(denominator));
		BigInteger denom = aRational.denominator.multiply(denominator);		
		return new Rational(numer, denom);
	}
	
	public BigInteger numerator() {
		return numerator;
	}
	
	private BigInteger numerator;
	private BigInteger denominator;
	
}
