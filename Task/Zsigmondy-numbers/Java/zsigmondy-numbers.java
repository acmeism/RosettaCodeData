import java.util.ArrayList;
import java.util.Collections;
import java.util.List;

public final class ZsigmondyNumbers {

	public static void main(String[] args) {
		record Pair(int a, int b) {}
		List<Pair> pairs = List.of( new Pair(2, 1), new Pair(3, 1), new Pair(4, 1), new Pair(5, 1),
			new Pair(6, 1), new Pair(7, 1), new Pair(3, 2), new Pair(5, 3), new Pair(7, 3), new Pair(7, 5) );	
		
		for ( Pair pair : pairs ) {
			System.out.println("Zsigmondy(n, " + pair.a + ", " + pair.b + ")");
		    for ( int n = 1; n <= 18; n++ ) {
		        System.out.print(zsigmondyNumber(n, pair.a, pair.b) + " ");
		    }
		    System.out.println(System.lineSeparator());
		}
		
	}
	
	private static long zsigmondyNumber(int n, int a, int b) {
		final long dn = (long) ( Math.pow(a, n) - Math.pow(b, n) );
		if ( isPrime(dn) ) {
			return dn;
		}
		
		List<Long> divisors = divisors(dn);
		for ( int m = 1; m < n; m++ ) {
		    long dm = (long) ( Math.pow(a, m) - Math.pow(b, m) );
		    divisors.removeIf( d -> gcd(dm, d) > 1 );
		}
		return divisors.get(divisors.size() - 1);
	}
	
	private static List<Long> divisors(long number) {
		List<Long> result = new ArrayList<Long>();
		for ( long d = 1; d * d <= number; d++ ) {
			if ( number % d == 0 ) {
			    result.add(d);
			    if ( d * d < number ) {
			    	result.add(number / d);
			    }
			}			
		}
		Collections.sort(result);
		return result;
	}
	
	private static boolean isPrime(long number) {
		if ( number < 2 ) {
			return false;
		}
		if ( number % 2 == 0 ) {
			return number == 2;
		}
		if ( number % 3 == 0 ) {
			return number == 3;
		}
		
		int delta = 2;
		long k = 5;
		while ( k * k <= number ) {
		    if ( number % k == 0 ) {
		    	return false;
		    }
		    k += delta;
		    delta = 6 - delta;
		}
		return true;
	}
	
	private static long gcd(long a, long b) {
		while ( b != 0 ) {
			long temp = a; a = b; b = temp % b;
		}
		return a;
	}	

}
