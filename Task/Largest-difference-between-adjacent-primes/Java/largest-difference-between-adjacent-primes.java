import java.util.List;
import java.util.function.Predicate;
import java.util.stream.IntStream;
import java.util.stream.Stream;

public final class LargestDifferenceBetweenAdjacentPrimes {

	public static void main(String[] args) {
		Predicate<Integer> isPrime = n -> IntStream.rangeClosed(2, (int) Math.sqrt(n)).allMatch( i -> n % i > 0 );
		
		List<Integer> oddPrimes = Stream.iterate(3, i -> i < 1_000_000, i -> i + 2 )
				                        .filter( i -> isPrime.test(i) ).toList();
		
		final int maxDifference = IntStream.range(0, oddPrimes.size() - 1)
				                           .map( i -> oddPrimes.get(i + 1) - oddPrimes.get(i) ).max().getAsInt();
	
		System.out.println("The largest difference between adjacent primes is " + maxDifference);		
	}

}
