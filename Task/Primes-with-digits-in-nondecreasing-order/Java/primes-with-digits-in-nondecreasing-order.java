import java.util.function.IntPredicate;
import java.util.stream.IntStream;

public final class PrimesWithDigitsInNondecreasingOrder {

	public static void main(String[] args) {
		IntPredicate isPrime = n -> IntStream.rangeClosed(2, (int) Math.sqrt(n)).allMatch( i -> n % i > 0 );
		
		IntPredicate isNonDecreasing = n -> {
			int previous = 10;
		    while ( n > 0 ) {
		    	int digit = n % 10;
				if ( digit > previous ) {
					return false;
				}
				previous = digit;
				n /= 10;
		    }
		    return true;
		};
		
		IntStream.range(2, 1_000).forEach( i -> {
			if ( isPrime.test(i) && isNonDecreasing.test(i) ) {
				System.out.print(i + " ");
			}
		} );
		System.out.println();
	}

}
