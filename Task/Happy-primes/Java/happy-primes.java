import java.util.ArrayList;
import java.util.Collections;
import java.util.List;

public final class HappyPrimes {

	public static void main() {
		fillPrimes(10_000_000);
		
		IO.println("The first fifty happy primes:");
	    int n = 1;
	    int count = 0;
	    while ( count < 50 ) {
	        if ( isHappy(n) && isPrime(n) ) {
	        	count += 1;
	            IO.print("%4d%s".formatted(n, ( count % 10 == 0 ? "\n" : " " )));
	        }
	        n += 1;
	    }
	
	    IO.println("\nPrime\nfraction  Index    Value");
	    int number = 1;
	    int happyCount = 0;
	    int primeCount = 0;
	    int denominator = 2;
	    while ( denominator <= 15 ) {
	        if ( isHappy(number) ) {
	            happyCount += 1;
	            if ( isPrime(number) ) {
	            	primeCount += 1;
	            }
	            if ( (double) primeCount / happyCount <= 1.0 / denominator ) {
	                IO.println("1 / %-2d:  %6d  %7d".formatted(denominator, happyCount, number));
	                denominator += 1;
	            }
	        }
	
	        number += 1;	
	    }
	}
	
	private static boolean isHappy(int n) {
	    while ( n != 1 && n != 4 ) {
	    	n = String.valueOf(n).chars().map( ch -> Character.digit(ch, 10) ).map( i -> i * i ).sum();
	    }
	    return n == 1;
	}
	
	private static boolean isPrime(int n) {
		return Collections.binarySearch(primes, n) > 0;
	}
	
	private static void fillPrimes(int limit) {
		primes = new ArrayList<Integer>(List.of( 2 ));
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
	
	private static List<Integer> primes;

}
