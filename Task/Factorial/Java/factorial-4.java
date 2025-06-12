import java.math.BigInteger;
import java.util.function.Function;
import java.util.stream.LongStream;
import java.util.stream.Stream;

public final class Factorial {

	public static void main(String[] args) {
		// Valid only for integer arguments 1, 2, ... , 20
		Function<Integer, Long> factorialPositive = n -> LongStream.rangeClosed(2, n).reduce(1, (a, b) -> a * b);		
		
		// Valid for integer arguments <= 20
		Function<Integer, Long> factorial = n -> {
			if ( n < 0 || n > 20 ) {
				throw new AssertionError("Argument is out of range: " + n);
			}
			
			return factorialPositive.apply(n);
		};
		
		// Return a BigInteger value
		Function<Integer, BigInteger> factorialBig = n -> Stream.iterate(BigInteger.ONE, i -> i.add(BigInteger.ONE))
				                                                .limit(n)
				                                                .reduce(BigInteger.ONE, BigInteger::multiply);
	}

}
