import java.util.List;
import java.util.function.BiFunction;

public final class Coprimes {

	public static void main(String[] args) {		
		BiFunction<Integer, Integer, Integer> gcd = (a, b) -> {
			while ( b != 0 ) {
				final int temp = b;
				b = a % b;
				a = temp;
			}
			return a;
		};	
		
		record Pair(int first, int second) {}
		
		List.of( new Pair(21, 15), new Pair(17, 23), new Pair(36, 12), new Pair(18, 29), new Pair(60, 15) ).stream()		
			.filter( pair -> gcd.apply(pair.first, pair.second) == 1 )
			.forEach( pair -> System.out.println("(" + pair.first + ", " + pair.second + ")") );
	}
	
}
