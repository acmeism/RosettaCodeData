import java.util.ArrayList;
import java.util.Collections;
import java.util.List;
import java.util.stream.Collectors;

public final class PAdicNumbersBasic {

	public static void main(String[] args) {
		System.out.println("3-adic numbers:");
		Padic padicOne = new Padic(3, -5, 9);
		System.out.println("-5 / 9    => " + padicOne);
		Padic padicTwo = new Padic(3, 47, 12);
		System.out.println("47 / 12   => " + padicTwo);
		
		Padic sum = padicOne.add(padicTwo);
		System.out.println("sum       => " + sum);		
		System.out.println("Rational = " + sum.convertToRational());
		System.out.println();		
	
		System.out.println("7-adic numbers:");
		padicOne = new Padic(7, 5, 8);
		System.out.println("5 / 8         => " + padicOne);
		padicTwo = new Padic(7, 353, 30809);
		System.out.println("353 / 30809   => " + padicTwo);
		
		sum = padicOne.add(padicTwo);
		System.out.println("sum           => " + sum);			
		System.out.println("Rational = " + sum.convertToRational());
	}
}

final class Padic {	
	/**
	 * Create a p-adic, with p = aPrime, from the given rational 'aNumerator' / 'aDenominator'.
	 */
	public Padic(int aPrime, int aNumerator, int aDenominator) {
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
		
		// Standard calculation of p-adic digits
		final long inverse = moduloInverse(aDenominator);		
		while ( digits.size() < DIGITS_SIZE ) {
			final int digit = Math.floorMod(aNumerator * inverse, prime);
			digits.addLast(digit);
			
			aNumerator -= digit * aDenominator;
			
			if ( aNumerator != 0 ) {
			// The denominator is not a power of a prime
				int count = 0;
				while ( Math.floorMod(aNumerator, prime) == 0 ) {
					aNumerator /= prime;
					count += 1;
				}
				
				for ( int i = count; i > 1; i-- ) {
					digits.addLast(0);
				}
			}
		}		
	}
	
	/**
     * Return the sum of this p-adic number and the given p-adic number.
     */
    public Padic add(Padic aOther) {
    	if ( prime != aOther.prime ) {
    		throw new IllegalArgumentException("Cannot add p-adic's with different primes");
    	}
    	
        List<Integer> result = new ArrayList<Integer>();

        // Adjust the digits so that the p-adic points are aligned
        for ( int i = 0; i < -order + aOther.order; i++ ) {
        	aOther.digits.addFirst(0);
        }

        for ( int i = 0; i < -aOther.order + order; i++ ) {
        	digits.addFirst(0);
        }

        // Standard digit by digit addition
        int carry = 0;
        for ( int i = 0; i < Math.min(digits.size(), aOther.digits.size()); i++ ) {         	
            final int sum = digits.get(i) + aOther.digits.get(i) + carry;
            final int remainder = Math.floorMod(sum, prime);
            carry = ( sum >= prime ) ? 1 : 0;
            result.addLast(remainder);
        }

        // Reverse the changes made to the digits
        for ( int i = 0; i < -order + aOther.order; i++ ) {
        	aOther.digits.removeFirst();
        }

        for ( int i = 0; i < -aOther.order + order; i++ ) {
        	digits.removeFirst();
        }

        return new Padic(prime, result, allZeroDigits(result) ? MAX_ORDER : Math.min(order, aOther.order));
    }

    /**
     * Return the Rational representation of this p-adic number.
     */
    public Rational convertToRational() {
    	List<Integer> numbers = new ArrayList<Integer>(digits);    	
    	
    	// Zero
    	if ( numbers.isEmpty() || allZeroDigits(numbers) ) {
    		return new Rational(0, 1);
    	}    	
    	
    	// Positive integer
    	if ( order >= 0 && endsWith(numbers, 0) ) {
    		for ( int i = 0; i < order; i++ ) {
	    		numbers.addFirst(0);
	    	}
    		
	    	return new Rational(convertToDecimal(numbers), 1);
    	}    	
    	
    	// Negative integer
    	if ( order >= 0 && endsWith(numbers, prime - 1) ) { 	
	    	negateList(numbers);
	    	for ( int i = 0; i < order; i++ ) {
	    		numbers.addFirst(0);
	    	}
	    	
	    	return new Rational(-convertToDecimal(numbers), 1);
    	}    	

    	// Rational
    	Padic sum = new Padic(prime, digits, order);
    	Padic self = new Padic(prime, digits, order);
    	int denominator = 1;
    	do {
    		sum = sum.add(self);
    		denominator += 1;
    	} while ( ! ( endsWith(sum.digits, 0) || endsWith(sum.digits, prime - 1) ) );
    	
    	final boolean negative = endsWith(sum.digits, prime - 1);
    	if ( negative ) {
    		negateList(sum.digits);
    	}
    	
    	int numerator = negative ? -convertToDecimal(sum.digits) : convertToDecimal(sum.digits);
    	
    	if ( order > 0 ) {
    		numerator *= Math.pow(prime, order);
    	}
    	
    	if ( order < 0 ) {
    		denominator *= Math.pow(prime, -order);
    	}
    	
    	return new Rational(numerator, denominator);
    }

    /**
	 * Return a string representation of this p-adic.
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
	 * Create a p-adic, with p = 'aPrime', directly from a list of digits.
	 *
	 * With 'aOrder' = 0, the list [1, 2, 3, 4, 5] creates the p-adic ...54321.0
	 * 'aOrder' > 0 shifts the list 'aOrder' places to the left and
	 * 'aOrder' < 0 shifts the list 'aOrder' places to the right.
	 */
	private Padic(int aPrime, List<Integer> aDigits, int aOrder) {
		prime = aPrime;		
		digits = new ArrayList<Integer>(aDigits);
		order = aOrder;
	}	
	
	/**
	 * Return the multiplicative inverse of the given decimal number modulo 'prime'.
	 */
	private int moduloInverse(int aNumber) {
		int inverse = 1;
		while ( Math.floorMod(inverse * aNumber, prime) != 1 ) {
			inverse += 1;
		}	
		
		return inverse;
	}
	
	/**
	 * Transform the given list of digits representing a p-adic number
	 * into a list which represents the negation of the p-adic number.
	 */
	private void negateList(List<Integer> aDigits) {		
		aDigits.set(0, Math.floorMod(prime - aDigits.get(0), prime));
    	for ( int i = 1; i < aDigits.size(); i++ ) {
    		aDigits.set(i, prime - 1 - aDigits.get(i));
    	}
	}	
	
	/**
	 * Return the given list of base 'prime' integers converted to a decimal integer.
	 */
	private int convertToDecimal(List<Integer> aNumbers) {
		int decimal = 0;
		int multiple = 1;
		for ( int number : aNumbers ) {
			decimal += number * multiple;				
			multiple *= prime;
		}
		
		return decimal;
	}
	
	/**
	 * Return whether the given list consists of all zeros.
	 */
	private static boolean allZeroDigits(List<Integer> aList) {
		return aList.stream().allMatch( i -> i == 0 );
	}
	
	/**
	 * The given list is padded on the right by zeros up to a maximum length of 'PRECISION'.
	 */
	private static void padWithZeros(List<Integer> aList) {
		while ( aList.size() < DIGITS_SIZE ) {
			aList.addLast(0);
		}
	}
	
	/**
	 * Return whether the given list ends with multiple instances of the given number.
	 */
	private static boolean endsWith(List<Integer> aDigits, int aDigit) {
		for ( int i = aDigits.size() - 1; i >= aDigits.size() - PRECISION / 2; i-- ) {
			if ( aDigits.get(i) != aDigit ) {
				return false;
			}
		}
		
		return true;
	}
	
	private static class Rational {
		
		public Rational(int aNumerator, int aDenominator) {
			if ( aDenominator < 0 ) {
	    		numerator = -aNumerator;
	    		denominator = -aDenominator;
	    	} else {
	    		numerator = aNumerator;
	    		denominator = aDenominator;
	    	}
			
			if ( aNumerator == 0 ) {
	    		denominator = 1;
	    	}			
	    	
	    	final int gcd = gcd(numerator, denominator);
	    	numerator /= gcd;
	    	denominator /= gcd;	
		}
		
		public String toString() {
			return numerator + " / " + denominator;
		}
		
		private int gcd(int aOne, int aTwo) {
			if ( aTwo == 0 ) {
	    		return Math.abs(aOne);
	    	}
	    	return gcd(aTwo, Math.floorMod(aOne, aTwo));
		}
		
		private int numerator;
		private int denominator;
		
	}
	
	private List<Integer> digits;
	private int order;
	
	private final int prime;	
	
	private static final int MAX_ORDER = 1_000;
	private static final int PRECISION = 40;
	private static final int DIGITS_SIZE = PRECISION + 5;

}
