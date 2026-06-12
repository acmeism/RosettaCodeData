import java.util.List;
import java.util.function.Function;
import java.util.stream.IntStream;

public final class CousinPrimes {

	public static void main(String[] args) {
		Function<Integer, Boolean> isPrime = p ->
			IntStream.rangeClosed(2, (int) Math.sqrt(p)).noneMatch( i -> p % i == 0 );
		
		final int limit = 1_000;
		List<Integer> primes = IntStream.range(2, limit).filter( i -> isPrime.apply(i) ).boxed().toList();		
		
		List<CousinPrime> cousins = primes.stream().filter( i -> primes.contains(i + 4) )
				                          .map( i -> new CousinPrime(i, i + 4) ).toList();
		
		System.out.println("Number of cousin prime pairs less than " + limit + ": " + cousins.size());
		IntStream.range(0, cousins.size()).forEach( i ->
			System.out.print(String.format("%10s%s", cousins.get(i), ( i % 7 == 6 ) ? "\n" : " " )) );
	}

	private record CousinPrime(int lowerPrime, int upperPrime) {
		
		public String toString() {
			return "(" + lowerPrime + ", " + upperPrime + ")";
		}
		
	}

}
