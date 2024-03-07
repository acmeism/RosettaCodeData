import java.math.BigInteger;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;

public class CyclotomicPolynomials {

	public static void main(String[] args) {
		System.out.println("Task 1: Cyclotomic polynomials for n <= 30:");
        for ( int cpIndex = 1; cpIndex <= 30; cpIndex++ ) {
        	System.out.println("CP[" + cpIndex + "] = " + toString(cyclotomicPolynomial(cpIndex)));
        }

        System.out.println();
        System.out.println("Task 2: Smallest cyclotomic polynomial with n or -n as a coefficient:");
        System.out.println("CP[1] has a coefficient with magnitude 1");
        int cpIndex = 2;
        for ( int coefficient = 2; coefficient <= 10; coefficient++ ) {
            while ( BigInteger.valueOf(cpIndex).isProbablePrime(PRIME_CERTAINTY)
            		|| ! hasHeight(cyclotomicPolynomial(cpIndex), coefficient) ) {
            	cpIndex += 1;           	
            }
            System.out.println("CP[" + cpIndex + "] has a coefficient with magnitude " + coefficient);
        }
	}
	
	// Return the Cyclotomic Polynomial of order 'cpIndex' as an array of coefficients,
	// where, for example, the polynomial 3x^2 - 1 is represented by the array [3, 0, -1].
	private static int[] cyclotomicPolynomial(int cpIndex) {
		int[] polynomial = new int[] { 1, -1 };
		if ( cpIndex == 1 ) {
			return polynomial;
		}
		
		if ( BigInteger.valueOf(cpIndex).isProbablePrime(PRIME_CERTAINTY) ) {
			int[] result = new int[cpIndex];
			Arrays.fill(result, 1);
			return result;
		}
		
		List<Integer> primes = distinctPrimeFactors(cpIndex);
		int product = 1;
		for ( int prime : primes ) {
			int[] numerator = substituteExponent(polynomial, prime);
			polynomial = exactDivision(numerator, polynomial);
			product *= prime;
		}
		
		polynomial = substituteExponent(polynomial, cpIndex / product);		
		return polynomial;
	}
	
	// Return the Cyclotomic Polynomial obtained from 'polynomial' by replacing x with x^'exponent'.	
	private static int[] substituteExponent(int[] polynomial, int exponent) {
		int[] result = new int[exponent * ( polynomial.length - 1 ) + 1];
		for ( int i = polynomial.length - 1; i >= 0; i-- ) {
			result[i * exponent] = polynomial[i];
		}
		
		return result;
	}
	
	// Return the Cyclotomic Polynomial equal to 'dividend' / 'divisor'. The division is always exact.
	private static int[] exactDivision(int[] dividend, int[] divisor) {
		int[] result = Arrays.copyOf(dividend, dividend.length);
	    for ( int i = 0; i < dividend.length - divisor.length + 1; i++ ) {
	        if ( result[i] != 0 ) {
	            for ( int j = 1; j < divisor.length; j ++ ) {
	                result[i + j] += -divisor[j] * result[i];
	            }
	        }
	    }
	
	    result = Arrays.copyOf(result, result.length - divisor.length + 1);
	    return result;
	}

	// Return whether 'polynomial' has a coefficient of equal magnitude to 'coefficient'.
	private static boolean hasHeight(int[] polynomial, int coefficient) {
        for ( int i = 0; i <= ( polynomial.length + 1 ) / 2; i++ ) {
            if ( Math.abs(polynomial[i]) == coefficient ) {
                return true;
            }
        }

        return false;
    }
	
	// Return a string representation of 'polynomial'.
	private static String toString(int[] polynomial) {
        StringBuilder text = new StringBuilder();
        for ( int i = 0; i < polynomial.length; i++ ) {
        	if ( polynomial[i] == 0 ) {
        		continue;
        	}
        	
        	text.append(( polynomial[i] < 0 ) ?	( ( i == 0 ) ? "-" : " - " ) : ( ( i == 0 ) ? "" : " + " ));
        	
        	final int exponent = polynomial.length - 1 - i;
        	if ( exponent > 0 && Math.abs(polynomial[i]) > 1 ) {
        		text.append(Math.abs(polynomial[i]));
        	}        	
        	
        	text.append(( exponent > 1 ) ?
        		( "x^" + String.valueOf(exponent) ) : ( ( exponent == 1 ) ? "x" : Math.abs(polynomial[i]) ));
        }

        return text.toString();
    }
	
	// Return a list of the distinct prime factors of 'number'.
	private static List<Integer> distinctPrimeFactors(int number) {		
    	List<Integer> primeFactors = new ArrayList<Integer>();
    	for ( int divisor = 2; divisor * divisor <= number; divisor++ ) {
    		if ( number % divisor == 0 ) {
    			primeFactors.add(divisor);
    		}
    		while ( number % divisor == 0 ) {
    			number = number / divisor;
    		}
    	}
    	
    	if ( number > 1 ) {
    		primeFactors.add(number);
    	}
    	
    	return primeFactors;
    }
	
	private static final int PRIME_CERTAINTY = 15;

}
