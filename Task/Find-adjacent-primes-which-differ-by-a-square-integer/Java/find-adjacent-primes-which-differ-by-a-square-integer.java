import java.util.ArrayList;
import java.util.List;

public final class FindAdjacentPrimesWhichDifferByASquareInteger {

	public static void main(String[] args) {
		List<Integer> primes = listPrimeNumbers(1_000_000);
		
		for ( int i = 2; i < primes.size(); i++ ) {
			final int prime2 = primes.get(i - 1);
			final int prime1 = primes.get(i);
		    final int difference = prime1 - prime2;
		    if ( difference > 36 && isSquare(difference) ) {
		    	System.out.println(String.format("%12s%9s%s",
		    		prime2 + " and ", prime1 + " : ", "difference = " + difference));
		    }
		}
	}
	
	private static boolean isSquare(int number) {
		return Math.pow((int) Math.sqrt(number), 2) == number;
	}
	
	private static List<Integer> listPrimeNumbers(int limit) {
		List<Integer> primes = new ArrayList<Integer>();
		primes.add(2);
		final int halfLimit = ( limit + 1 ) / 2;
		boolean[] composite = new boolean[halfLimit];
		for ( int i = 1, p = 3; i < halfLimit; p += 2, i++ ) {
			if ( ! composite[i] ) {
				primes.add(p);
				for ( int a = i + p; a < halfLimit; a += p ) {
					composite[a] = true;
				}
			}
		}
		return primes;
	}	

}
