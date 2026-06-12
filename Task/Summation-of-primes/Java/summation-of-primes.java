import java.util.function.Predicate;
import java.util.stream.LongStream;

public final class SummationOfPrimes {

	public static void main(String[] args) {
		Predicate<Long> isPrime = n -> LongStream.rangeClosed(2, (int) Math.sqrt(n)).allMatch( i -> n % i > 0 );
		
		System.out.println(LongStream.range(2, 2_000_000).filter( n -> isPrime.test(n) ).sum());
	}

}
