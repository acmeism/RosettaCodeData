import module java.base;

public final class HigherOrderFunctions {

	public static void main() {
		Function<Integer, Integer> square = n -> n * n;
		
		Function<Integer, Integer> cube = n -> n * n * n;
		
		BiConsumer<String, Function<Integer, Integer>> demonstration = (s, f) -> {
			IO.print(s + " => ");
			IntStream.rangeClosed(1, 9).forEach( i -> IO.print("%4s".formatted(f.apply(i))) );
			IO.println();			
		};
		
		demonstration.accept("Squares", square);
		demonstration.accept("Cubes  ", cube);
	}

}
