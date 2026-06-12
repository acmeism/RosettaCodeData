import java.util.List;
import java.util.stream.Collectors;
import java.util.stream.Stream;

public final class CoprimeTriplets {

	public static void main(String[] args) {
		List<Integer> coprimes = Stream.of( 1, 2 ).collect(Collectors.toList());

		int n = 3;
		while ( n < 50 ) {
			n = 3;
		    final int previous2 = coprimes.get(coprimes.size() - 2);
		    final int previous1 = coprimes.getLast();
		    while ( coprimes.contains(n) || gcd(n, previous2) != 1 || gcd(n, previous1) != 1 ) {
		        n += 1;
		    }
		    if ( n < 50 ) {
		    	coprimes.addLast(n);
		    }
		}
		
		System.out.println(coprimes.stream().map( i -> String.valueOf(i) ).collect(Collectors.joining(" ")));
	}
	
	private static int gcd(int a, int b) {
		return ( b == 0 ) ? a : gcd(b, a % b);
	}

}
