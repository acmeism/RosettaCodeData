import java.util.List;
import java.util.function.Predicate;
import java.util.stream.IntStream;

public final class SortPrimesFromListToAList {

	public static void main(String[] args) {
		Predicate<Integer> isPrime = n -> IntStream.rangeClosed(2, (int) Math.sqrt(n)).allMatch( i -> n % i > 0 );
		
		System.out.println(List.of( 2, 43, 81, 122, 63, 13, 7, 95, 103 )
			.stream().filter( i -> isPrime.test(i) ).sorted().toList());
	}

}
