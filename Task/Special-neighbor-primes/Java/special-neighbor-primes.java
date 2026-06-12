import java.util.function.Function;
import java.util.function.Predicate;
import java.util.stream.IntStream;

public final class SpecialNeighborPrimes {

	public static void main(String[] args) {
		Predicate<Integer> isPrime = n -> IntStream.rangeClosed(2, (int) Math.sqrt(n)).allMatch( i -> n % i > 0 );
		
		Function<Integer, Integer> nextPrime =
			n -> IntStream.iterate(n + 2, i -> i + 2 ).filter( i -> isPrime.test(i) ).findFirst().getAsInt();
			
		IntStream.iterate(3, i -> i + 2 ).forEach( i -> {
			if ( isPrime.test(i) ) {
				final int next = nextPrime.apply(i);
				if ( next < 100 && isPrime.test(i + next - 1) ) {
					System.out.println(i + " + " + next + " - 1 = " + ( i + next - 1 ));
				}
			}			
		} );
	}

}
