import java.math.BigDecimal;
import java.math.MathContext;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.function.Function;
import java.util.stream.IntStream;

public final class TriangularNumbers {

	public static void main(String[] args) {		
		printSimplexNumbers("The first 30 triangular numbers:", 30, 2, 3);
		printSimplexNumbers("The first 30 tetrahedral numbers:", 30, 3, 4);
		printSimplexNumbers("The first 30 pentatopic numbers:", 30, 4, 5);
		printSimplexNumbers("The first 30 12-simplex numbers:", 30, 12, 10);
		
		Function<Long, Double> triangularRoot = n -> ( Math.sqrt(8 * n + 1) - 1 ) * 0.5;
		
		Function<Long, Double> tetrahedralRoot = n -> {
			BigDecimal t1 = new BigDecimal(3 * n);
			BigDecimal t2 = t1.multiply(t1).subtract(
				BigDecimal.ONE.divide( new BigDecimal(27), MathContext.DECIMAL128 )).sqrt(MathContext.DECIMAL128);			
			final double sum = t1.add(t2).doubleValue();
			final double difference = t1.subtract(t2).doubleValue();			
			return Math.cbrt(sum) + Math.cbrt(difference) - 1.0;			
		};

		Function<Long, Double> pentatopicRoot = n -> ( Math.sqrt(5 + 4 * Math.sqrt(24 * n + 1)) - 3 ) * 0.5;
		
		List.of( 7_140L, 21_408_696L, 26_728_085_384L, 14_545_501_785_001L ).forEach( n -> {
			System.out.println("Roots of " + n);
			System.out.println("    triangular: %.6f".formatted(triangularRoot.apply(n)));
			System.out.println("    tetrahedral: %.6f".formatted(tetrahedralRoot.apply(n)));
			System.out.println("    pentatopic: %.6f".formatted(pentatopicRoot.apply(n)));
			System.out.println();
		} );
	}
	
	private static void printSimplexNumbers(String title, int n, int r, int width) {
	    System.out.println(title);
	    IntStream.rangeClosed(1, n).forEach( i -> System.out.print(String.format("%" + width + "d%s",
	    	binomialCoefficient(i + r - 1, r), ( ( i % 5 == 0 ) ? "\n" : " " ) ) ) );
	    System.out.println();
	}
	
	private static long binomialCoefficient(int n, int r) {
	    if ( n == r || r == 0 ) {
            return 1;
	    }
	
	    Pair pair = new Pair(n, r);	
	    if ( ! cache.containsKey(pair) ) {
	    	cache.put(pair, binomialCoefficient(n - 1, r - 1) + binomialCoefficient(n - 1, r));
	    }
        return cache.get(pair);
    }
	
	private record Pair(int n, int r) {}
	
	private static Map<Pair, Long> cache = new HashMap<Pair, Long>();

}
