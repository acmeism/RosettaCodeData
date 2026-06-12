import java.math.BigInteger;
import java.util.List;
import java.util.function.Function;
import java.util.stream.IntStream;

public final class SpecialFactorials {

	public static void main(String[] args) {
		testFactorial(superFactorial, 10, " super factorials:");
		testFactorial(hyperFactorial, 10, " hyper factorials:");
		testFactorial(alternatingFactorial, 10, " alternating factorials:");
		testFactorial(exponentialFactorial, 5, " exponential factorials:");
		
		List.of( 1, 2, 6, 24, 120, 720, 5040, 40320, 362880, 3628800, 119 ).forEach( number -> testInverse(number) );		
	}	
	
	private static void testFactorial(Function<Integer, BigInteger> function, int count, String name) {
	    System.out.println("First " + count + name);
	    IntStream.range(0, count).forEach( i -> {
	        System.out.print(function.apply(i) + " ");
	    } );
	    System.out.println(System.lineSeparator());
	}
	
	private static void testInverse(long n) {
	    final long inverse = inverseFactorial.apply(BigInteger.valueOf(n));
	    System.out.print("inverseFactorial(" + n + ") ");
	    System.out.println(( inverse == -1 ) ? "has no solution" : "= " + inverse);
	};
	
	// Return factorial(n) = n! = 1 * 2 * 3 * ... * n
	private static Function<Integer, BigInteger> factorial = n -> {
	    BigInteger result = BigInteger.ONE;
	    for ( int i = 2; i <= n; i++ ) {
	    	result = result.multiply(BigInteger.valueOf(i));
	    }
	    return result;
	};
	
	// Return superFactorial(n) = 1! * 2! * 3! * ... . n!
	private static Function<Integer, BigInteger> superFactorial = n -> {
	    BigInteger result = BigInteger.ONE;
	    for ( int i = 2; i <= n; i++ ) {
	        result = result.multiply(factorial.apply(i));
	    }
	    return result;
	};
	
	// Return hyperFactorial(n) = 1^1 * 2^2 * 3^3 * ... * n^n
	private static Function<Integer, BigInteger> hyperFactorial = n -> {
	    BigInteger result = BigInteger.ONE;
	    for ( int i = 1; i <= n; i++ ) {
	        result = result.multiply(BigInteger.valueOf(i).pow(i));
	    }
	    return result;
	};
	
	// Return alternatingFactorial(n) = -1^(n-1) * 1! + -1^(n-2) * 2! + ... + -1^(0) * n!
	private static Function<Integer, BigInteger> alternatingFactorial = n -> {
	    BigInteger result = BigInteger.ZERO;
	    for ( int i = 1; i <= n; i++ ) {
	    	result = ( ( n - i ) % 2 == 0 ) ? result.add(factorial.apply(i)) : result.subtract(factorial.apply(i));
	    }
	    return result;
	};
	
	// Return exponentialFactorial(n) = n ^ (n - 1) ^ ... ^ (2) ^ 1
	private static Function<Integer, BigInteger> exponentialFactorial = n -> {
	    BigInteger result = BigInteger.ZERO;
	    for ( int i = 1; i <= n; i++ ) {
	        result = BigInteger.valueOf(i).pow(result.intValueExact());
	    }
	    return result;
	};
	
	// Return inverseFactorial(n) = a, if and only if factorial(a) = n
	private static Function<BigInteger, Integer> inverseFactorial = big -> {
	    if ( big.compareTo(BigInteger.ONE) == 0 ) {
	        return 0;
	    }

	    BigInteger product = BigInteger.ONE;
	    BigInteger multiplier = BigInteger.ONE;
	    while ( product.compareTo(big) < 0 ) {
	        product = product.multiply(multiplier);
	        multiplier = multiplier.add(BigInteger.ONE);
	    }

	    if ( product.compareTo(big) == 0 ) {
	        return multiplier.intValueExact() - 1;
	    }
	    return -1;
	};	

}
