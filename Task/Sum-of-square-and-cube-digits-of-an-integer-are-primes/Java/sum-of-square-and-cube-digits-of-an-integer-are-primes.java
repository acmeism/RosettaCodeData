import java.util.function.Function;
import java.util.function.Predicate;
import java.util.stream.IntStream;

public final class SumOfSquareAndCubeDigitsOfAnIntegerArePrimes {

	public static void main(String[] args) {
		Predicate<Integer> isPrime = n ->
			n > 1 && IntStream.rangeClosed(2, (int) Math.sqrt(n)).allMatch( i -> n % i != 0 );
		
		Function<Integer, Integer> digitSum = number -> {
			int sum = 0;
			while ( number > 0 ) {
				sum += number % 10;
				number /= 10;
			}
			return sum;
		};
		
		System.out.println(IntStream.range(1, 100)
			.filter( n -> isPrime.test(digitSum.apply(n * n)) && isPrime.test(digitSum.apply(n * n * n)) )
			.boxed().toList());
	}		
	
}
