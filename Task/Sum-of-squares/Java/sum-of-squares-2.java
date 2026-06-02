import module java.base;

public final class SumOfSquares {

	public static void main() {		
		Function<List<Integer>, Integer> sumOfSquares = list -> list.stream().mapToInt( i -> i * i ).sum();
		
		List<List<Integer>> tests = List.of( List.of(), List.of( 1, 2, 3, 4, 5 ) );
		
		tests.forEach( list -> IO.println(list + " => " + sumOfSquares.apply(list)) );
	}

}
