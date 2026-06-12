import java.util.List;
import java.util.function.Function;
import java.util.function.Predicate;
import java.util.stream.IntStream;

public final class SpecialDivisors {

	public static void main(String[] args) {
		Function<Integer, List<Integer>> properDivisors =
			n -> IntStream.rangeClosed(1, n / 2).filter( i -> n % i == 0 ).boxed().toList();
			
		Function<Integer, Integer> reversed =
			n -> Integer.parseInt( new StringBuilder(String.valueOf(n)).reverse().toString() );
		
		Predicate<Integer> special = n -> {
			final int reversedN = reversed.apply(n);
			for ( int divisor : properDivisors.apply(n) ) {
				if ( reversedN % reversed.apply(divisor) > 0 ) {
					return false;
				}
			}
			return true;
		};
			
		for ( int n = 1, count = 0; n < 200; n++ ) {
			if ( special.test(n) ) {
				count += 1;
				System.out.print("%3d%s".formatted(n, ( count % 10 == 0 ? "\n" : " " )));
			}
		}
	}

}
