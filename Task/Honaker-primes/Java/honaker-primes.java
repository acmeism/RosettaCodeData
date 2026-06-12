import java.util.ArrayList;
import java.util.List;

public final class HonakerPrimes {

	public static void main(String[] args) {
		sievePrimes(5_000_000);
		
		System.out.println("The first 50 Honaker primes (honaker index: prime index, prime):");
	    for ( int i = 1; i <= 50; i++ ) {
	        System.out.print(String.format("%17s%s", nextHonakerPrime(), ( i % 5 == 0 ? "\n" : " " ) ));
	    }
	    for ( int i = 51; i < 10_000; i++ ) {
	    	nextHonakerPrime();
	    }
	    System.out.println();
	    System.out.println("The 10,000th Honaker prime is: " + nextHonakerPrime());
	}
	
	private static HonakerPrime nextHonakerPrime() {
		honakerIndex += 1;
		primeIndex += 1;
		while ( digitalSum(primeIndex) != digitalSum(primes.get(primeIndex - 1)) ) {
			primeIndex += 1;
		}
		return new HonakerPrime(honakerIndex, primeIndex, primes.get(primeIndex - 1));
	}
	
	private static int digitalSum(int number) {
		return String.valueOf(number).chars().map( i -> i - (int) '0' ).sum();
	}	

	private static void sievePrimes(int limit) {
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
	}
	
	private static int honakerIndex = 0;
	private static int primeIndex = 0;
	private static List<Integer> primes = new ArrayList<Integer>();	
	
	private static record HonakerPrime(int honakerIndex, int primeIndex, int prime) {
		
		public String toString() {
			return "(" + honakerIndex + ": " + primeIndex + ", " + prime + ")";
		}
		
	}

}
