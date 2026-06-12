import java.math.BigInteger;
import java.util.List;
import java.util.stream.Collectors;
import java.util.stream.Stream;

public final class SmallestNumbers {

	public static void main(String[] args) {
		final int limit = 50;
		List<Integer> values = Stream.generate( () -> 0 ).limit(limit + 1).collect(Collectors.toList());
		
		int k = 1;
		while ( values.stream().anyMatch( i -> i == 0 ) ) {
			String candidate = BigInteger.valueOf(k).pow(k).toString();
			for ( int i = 0; i <= limit; i++ ) {
				if ( values.get(i) == 0 && candidate.contains(String.valueOf(i)) ) {
					values.set(i, k);
				}
			}
			k += 1;
		}
	
		System.out.println("Smallest values of k such that k^k contains n:");
		for ( int i = 0; i < values.size(); i++ ) {
			System.out.print("%2d => %-2d   %s".formatted(i, values.get(i), ( i % 9 == 8 ? "\n" : "" )));
		}
		System.out.println();
	}

}
