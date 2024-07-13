import java.math.BigDecimal;
import java.math.BigInteger;
import java.math.MathContext;
import java.math.RoundingMode;
import java.util.ArrayList;
import java.util.Collections;
import java.util.List;
import java.util.stream.Collectors;

public final class PAdicSquareRoots {

	public static void main(String[] args) {
		List<List<Integer>> tests = List.of( List.of( 2, 497, 10496 ),				
				                             List.of( 3, 15403, 26685 ),
				                             List.of( 7, -19, 1 ) );
		
		for ( List<Integer> test : tests ) {		
			System.out.println("Number: " + test.get(1) + " / " + test.get(2) + " in " + test.get(0) + "-adic");
			PadicSquareRoot squareRoot = new PadicSquareRoot(test.get(0), test.get(1), test.get(2));
			System.out.println("The two square roots are:");
			System.out.println("    " + squareRoot);
			System.out.println("    " + squareRoot.negate());
			PadicSquareRoot square = squareRoot.multiply(squareRoot);
			System.out.println("The p-adic value is " + square);
			System.out.println("The rational value is " + square.convertToRational());
			System.out.println();
		}
	}
	
}
	
final class PadicSquareRoot {	
	/**
	 * Create a PadicSquareRoot number, with p = 'aPrime',
	 * which is the p-adic square root of the given rational 'aNumerator' / 'aDenominator'.
	 */
	public PadicSquareRoot(int aPrime, int aNumerator, int aDenominator) {
		if ( aDenominator == 0 ) {
			throw new IllegalArgumentException("Denominator cannot be zero");
		}	
			
		prime = aPrime;	
		digits = new ArrayList<Integer>(DIGITS_SIZE);
		order = 0;		
		
		// Process rational zero
		if ( aNumerator == 0 ) {
			order = MAX_ORDER;					
			return;
		}

		// Remove multiples of 'prime' and adjust the order of the p-adic number accordingly
		while ( Math.floorMod(aNumerator, prime) == 0 ) {			
			aNumerator /= prime;
			order += 1;
		}
		
		while ( Math.floorMod(aDenominator, prime) == 0 ) {			
			aDenominator /= prime;
			order -= 1;
		}		
		
		if ( ( order & 1 ) != 0 ) {
			throw new AssertionError("Number does not have a square root in " + prime + "-adic");
		}
		order >>= 1;
		
		if ( prime == 2 ) {
			squareRootEvenPrime(aNumerator, aDenominator);
		} else {
			squareRootOddPrime(aNumerator, aDenominator);
		}
	}
	
	/**
     * Return the additive inverse of this PadicSquareRoot number.
     */
    public PadicSquareRoot negate() {
    	if ( digits.isEmpty() ) {
    		return this;
    	}   	
    	
    	List<Integer> negated = new ArrayList<Integer>(digits);
    	negateDigits(negated);
  	
    	return new PadicSquareRoot(prime, negated, order);
    }
	
    /**
     * Return the product of this PadicSquareRoot number and the given PadicSquareRoot number.
     */
    public PadicSquareRoot multiply(PadicSquareRoot aOther) {
    	if ( prime != aOther.prime ) {
    		throw new IllegalArgumentException("Cannot multiply p-adic's with different primes");
    	}
    	
    	if ( digits.isEmpty() || aOther.digits.isEmpty() ) {
    		return new PadicSquareRoot(prime, 0 , 1);
    	}
    	
	    return new PadicSquareRoot(prime, multiply(digits, aOther.digits), order + aOther.order);    	
    }
	
	/**
     * Return a string representation of this PadicSquareRoot as a rational number.
     */
    public String convertToRational() {     	
    	List<Integer> numbers = new ArrayList<Integer>(digits);
    	
    	if ( numbers.isEmpty() ) {
    		return "0 / 1";
    	}

    	// Lagrange lattice basis reduction in two dimensions
    	long seriesSum = numbers.getFirst();
    	long maximumPrime = 1;    	
    	
    	for ( int i = 1; i < PRECISION; i++ ) {
    		maximumPrime *= prime;
    		seriesSum += numbers.get(i) * maximumPrime;
    	}

    	final MathContext mathContext = new MathContext(PRECISION, RoundingMode.HALF_UP);
    	final BigDecimal primeBig = BigDecimal.valueOf(prime);
    	final BigDecimal maximumPrimeBig = BigDecimal.valueOf(maximumPrime);
    	final BigDecimal seriesSumBig = BigDecimal.valueOf(seriesSum);
    	
    	BigDecimal[] one = new BigDecimal[] { maximumPrimeBig, seriesSumBig };
		BigDecimal[] two = new BigDecimal[] { BigDecimal.ZERO, BigDecimal.ONE };
		
		BigDecimal previousNorm = BigDecimal.valueOf(seriesSum).pow(2).add(BigDecimal.ONE);
		BigDecimal currentNorm = previousNorm.add(BigDecimal.ONE);
		int i = 0;
		int j = 1;
		
		while ( previousNorm.compareTo(currentNorm) < 0 ) {
			currentNorm = one[i].multiply(one[j]).add(two[i].multiply(two[j])).divide(previousNorm, mathContext);
			currentNorm = currentNorm.setScale(0, RoundingMode.HALF_UP);
		    one[i] = one[i].subtract(currentNorm.multiply(one[j]));
		    two[i] = two[i].subtract(currentNorm.multiply(two[j]));

		    currentNorm = previousNorm;
		    previousNorm = one[i].multiply(one[i]).add(two[i].multiply(two[i]));
		
		    if ( previousNorm.compareTo(currentNorm) < 0 ) {
		        final int temp = i; i = j; j = temp;
		    }
		}
		
		BigDecimal x = one[j];
		BigDecimal y = two[j];
		if ( y.signum() == -1 ) {
            y = y.negate();
            x = x.negate();
        }
	
	    if ( ! one[i].multiply(y).subtract(x.multiply(two[i])).abs().equals(maximumPrimeBig) ) {
			throw new AssertionError("Rational reconstruction failed.");
		}
	
	    for ( int k = order; k < 0; k++ ) {
			y = y.multiply(primeBig);
		}
	
	    for ( int k = order; k > 0; k-- ) {
	    	x = x.multiply(primeBig);
	    }

	    return x + " / " + y;		
    }

    /**
	 * Return a string representation of this PadicSquareRoot number.
	 */
	public String toString() {
		List<Integer> numbers = new ArrayList<Integer>(digits);
		padWithZeros(numbers);
		Collections.reverse(numbers);		
		String numberString = numbers.stream().map(String::valueOf).collect(Collectors.joining());
		StringBuilder builder = new StringBuilder(numberString);
				
		if ( order >= 0 ) {
			for ( int i = 0; i < order; i++ ) {
				builder.append("0");
			}
			
			builder.append(".0");
		} else {
			builder.insert(builder.length() + order, ".");
			
			while ( builder.toString().endsWith("0") ) {
				builder.deleteCharAt(builder.length() - 1);
			}
		}		
		
		return " ..." + builder.toString().substring(builder.length() - PRECISION - 1);
	}	
    		
	// PRIVATE //
	
	/**
	 * Create a PadicSquareRoot, with p = 'aPrime', directly from a list of digits.
	 *
	 * With 'aOrder' = 0, the list [1, 2, 3, 4, 5] creates the p-adic ...54321.0
	 * 'aOrder' > 0 shifts the list 'aOrder' places to the left and
	 * 'aOrder' < 0 shifts the list 'aOrder' places to the right.
	 */
	private PadicSquareRoot(int aPrime, List<Integer> aDigits, int aOrder) {
		prime = aPrime;		
		digits = new ArrayList<Integer>(aDigits);
		order = aOrder;
	}	
	
	/**
	 * Create a 2-adic number which is the square root of the rational 'aNumerator' / 'aDenominator'.
	 */
    private void squareRootEvenPrime(int aNumerator, int aDenominator) {
    	if ( Math.floorMod(aNumerator * aDenominator, 8) != 1 ) {
			throw new AssertionError("Number does not have a square root in 2-adic");
		}

		// First digit
		BigInteger sum = BigInteger.ONE;
		digits.addLast(sum.intValue());
		
		// Further digits
		final BigInteger numerator = BigInteger.valueOf(aNumerator);
		final BigInteger denominator = BigInteger.valueOf(aDenominator);
		
		while ( digits.size() < DIGITS_SIZE ) {
			BigInteger factor = denominator.multiply(sum.multiply(sum)).subtract(numerator);
			int valuation = 0;
			while ( factor.mod(BigInteger.TWO).signum() == 0 ) {
				factor = factor.shiftRight(1);
				valuation += 1;
			}
			
			sum = sum.add(BigInteger.TWO.pow(valuation - 1));			
			
			for ( int i = digits.size(); i < valuation - 1; i++ ) {
				digits.addLast(0);
			}
			digits.addLast(1);
		}
    }

    /**
	 * Create a p-adic number, with an odd prime number, p = 'prime',
	 * which is the p-adic square root of the given rational 'aNumerator' / 'aDenominator'.
	 */
    private void squareRootOddPrime(int aNumerator, int aDenominator) {
    	// First digit
		int firstDigit = 0;
		for ( int i = 1; i < prime && firstDigit == 0; i++ ) {
			if ( ( aDenominator * i * i - aNumerator ) % prime == 0 ) {
				firstDigit = i;
			}
		}
		
		if ( firstDigit == 0 ) {
			throw new IllegalArgumentException("Number does not have a square root in " + prime + "-adic");
		}
		
		digits.addLast(firstDigit);
		
		// Further digits
		final BigInteger numerator = BigInteger.valueOf(aNumerator);
		final BigInteger denominator = BigInteger.valueOf(aDenominator);		
		final BigInteger firstDigitBig = BigInteger.valueOf(firstDigit);
		final BigInteger primeBig = BigInteger.valueOf(prime);		
		final BigInteger coefficient =
			denominator.multiply(firstDigitBig).shiftLeft(1).mod(primeBig).modInverse(primeBig);		

		BigInteger sum = firstDigitBig;
		for ( int i = 2; i < DIGITS_SIZE; i++ ) {			
			BigInteger nextSum =
				sum.subtract(coefficient.multiply(denominator.multiply(sum).multiply(sum).subtract(numerator)));			
			nextSum = nextSum.mod(primeBig.pow(i));
			nextSum = nextSum.subtract(sum);
			sum = sum.add(nextSum);
			
			final int digit = nextSum.divideAndRemainder(primeBig.pow(i - 1))[0].intValueExact();
			digits.addLast(digit);
		}	
	}

    /**
	 * Return the list obtained by multiplying the digits of the given two lists,
	 * where the digits in each list are regarded as forming a single number in reverse.
	 * For example 12 * 13 = 156 is computed as [2, 1] * [3, 1] = [6, 5, 1].
	 */
	private List<Integer> multiply(List<Integer> aOne, List<Integer> aTwo) {
		List<Integer> product = new ArrayList<Integer>(Collections.nCopies(aOne.size() + aTwo.size(), 0));		
	    for ( int b = 0; b < aTwo.size(); b++ ) {
	    	int carry = 0;
		    for ( int a = 0; a < aOne.size(); a++ ) {
		        product.set(a + b, product.get(a + b) + aOne.get(a) * aTwo.get(b) + carry);
		        carry = product.get(a + b) / prime;
		        product.set(a + b, product.get(a + b) % prime);
		    }		
		    product.set(b + aOne.size(), carry);
	    }
	    	
	    return product.subList(0, DIGITS_SIZE);	
	}
	
	/**
	 * Transform the given list of digits representing a p-adic number
	 * into a list which represents the negation of the p-adic number.
	 */
	private void negateDigits(List<Integer> aDigits) {
		aDigits.set(0, Math.floorMod(prime - aDigits.get(0), prime));
    	for ( int i = 1; i < aDigits.size(); i++ ) {
    		aDigits.set(i, prime - 1 - aDigits.get(i));
    	}
	}	

	/**
	 * The given list is padded on the right by zeros up to a maximum length of 'DIGITS_SIZE'.
	 */
	private static void padWithZeros(List<Integer> aList) {
		while ( aList.size() < DIGITS_SIZE ) {
			aList.addLast(0);
		}
	}

	private List<Integer> digits;
	private int order;
	
	private final int prime;
		
	private static final int MAX_ORDER = 1_000;
	private static final int PRECISION = 20;
	private static final int DIGITS_SIZE = PRECISION + 5;	
	
}	
