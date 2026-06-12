import java.util.List;
import java.util.function.BiFunction;
import java.util.function.Predicate;
import java.util.stream.IntStream;

public final class NumbersWhoseBinaryAndTernaryDigitSumsArePrime {

	public static void main(String[] args) {
		Predicate<Integer> isPrime = p -> p > 1 &&
			IntStream.rangeClosed(2, (int) Math.sqrt(p)).allMatch( i -> p % i != 0 );	
			
		BiFunction<Integer, Integer, Integer> digitSumInBase = (number, base) -> {
			int sum = 0;
			while ( number > 0 ) {
				sum += number % base;
				number /= base;
			}
			return sum;
		};
		
		System.out.println("Numbers less than 200 whose binary and ternary digit sums are prime:");
		List<Integer> results = IntStream.range(2, 200)
			.filter( i -> isPrime.test(digitSumInBase.apply(i, 2)) && isPrime.test(digitSumInBase.apply(i, 3)) )
			.boxed().toList();

		IntStream.range(0, results.size()).forEach( i ->
			System.out.print(String.format("%3d%s", results.get(i), ( i % 16 == 15 ? "\n" : " " ))) );
	}	

}
