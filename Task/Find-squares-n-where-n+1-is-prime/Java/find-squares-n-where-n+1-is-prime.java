import java.util.List;
import java.util.function.IntPredicate;
import java.util.stream.Collectors;
import java.util.stream.IntStream;
import java.util.stream.Stream;

public final class FindSquaresNWhereNPlus1IsPrime {

	public static void main(String[] args) {
		IntPredicate isPrime = n -> IntStream.range(2, (int) Math.sqrt(n)).allMatch( i -> n % i > 0 );
		
		List<Integer> squares = Stream.of( 1 ).collect(Collectors.toList());
		final int limit = (int) Math.sqrt(1_000);
		
		int i = 2;
		while ( i <= limit ) {
		    final int n = i * i;
		    if ( isPrime.test(n + 1) ) {
		    	squares.addLast(n);
		    }
		    i += 2;
		}
		
		System.out.println(squares);
	}

}
