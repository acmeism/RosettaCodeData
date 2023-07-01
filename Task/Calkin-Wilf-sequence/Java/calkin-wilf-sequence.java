import java.util.ArrayDeque;
import java.util.Deque;

public final class CalkinWilfSequence {

	public static void main(String[] aArgs) {
		Rational term = Rational.ONE;
	    System.out.println("First 20 terms of the Calkin-Wilf sequence are:");
	    for ( int i = 1; i <= 20; i++ ) {
	    	System.out.println(String.format("%2d", i) + ": " + term);
	    	term = nextCalkinWilf(term);
	    }
	    System.out.println();
	
	    Rational rational = new Rational(83_116, 51_639);
	    System.out.println(" " + rational + " is the " + termIndex(rational) + "th term of the sequence.");

	}
	
	private static Rational nextCalkinWilf(Rational aTerm) {
		Rational divisor = Rational.TWO.multiply(aTerm.floor()).add(Rational.ONE).subtract(aTerm);
		return Rational.ONE.divide(divisor);
	}
	
	private static long termIndex(Rational aRational) {
	    long result = 0;
	    long binaryDigit = 1;
	    long power = 0;
	    for ( long term : continuedFraction(aRational) ) {
	        for ( long i = 0; i < term; power++, i++ ) {
	            result |= ( binaryDigit << power );
	        }
	        binaryDigit = ( binaryDigit == 0 ) ? 1 : 0;
	    }
	    return result;
	}
	
	private static Deque<Long> continuedFraction(Rational aRational) {
	    long numerator = aRational.numerator();
	    long denominator = aRational.denominator();
	    Deque<Long> result = new ArrayDeque<Long>();
	
	    while ( numerator != 1 ) {
	        result.addLast(numerator / denominator);
	        long copyNumerator = numerator;
	        numerator = denominator;
	        denominator = copyNumerator % denominator;
	    }
	
	    if ( ! result.isEmpty() && result.size() % 2 == 0 ) {
	    	final long back = result.removeLast();
	    	result.addLast(back - 1);
	        result.addLast(1L);
	    }
	    return result;
	}

}

final class Rational {
	
	public Rational(long aNumerator, long aDenominator) {
    	if ( aDenominator == 0 ) {
    		throw new ArithmeticException("Denominator cannot be zero");
    	}
    	if ( aNumerator == 0 ) {
    		aDenominator = 1;
    	}
    	if ( aDenominator < 0 ) {
    		numer = -aNumerator;
    		denom = -aDenominator;
    	} else {
    		numer = aNumerator;
    		denom = aDenominator;
    	}    	
    	final long gcd = gcd(numer, denom);
    	numer = numer / gcd;
    	denom = denom / gcd;
    }
	
	public Rational add(Rational aOther) {
    	return new Rational(numer * aOther.denom + aOther.numer * denom, denom * aOther.denom);
    }
	
	public Rational subtract(Rational aOther) {
		return new Rational(numer * aOther.denom - aOther.numer * denom, denom * aOther.denom);
	}

    public Rational multiply(Rational aOther) {
		return new Rational(numer * aOther.numer, denom * aOther.denom);
	}

    public Rational divide(Rational aOther) {
		return new Rational(numer * aOther.denom, denom * aOther.numer);
	}

    public Rational floor() {
    	return new Rational(numer / denom, 1);
    }

    public long numerator() {
    	return numer;
    }

    public long denominator() {
    	return denom;
    }

    @Override
    public String toString() {
    	return numer + "/" + denom;
    }

    public static final Rational ONE = new Rational(1, 1);
    public static final Rational TWO = new Rational(2, 1);

    private long gcd(long aOne, long aTwo) {
    	if ( aTwo == 0 ) {
    		return aOne;
    	}
    	return gcd(aTwo, aOne % aTwo);
    }

    private long numer;
    private long denom;

}
