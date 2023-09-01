import java.util.ArrayList;
import java.util.Collections;
import java.util.List;

public final class PrimeNumbersNeighboringPairsTetraprimes {

	public static void main(String[] aArgs) {
		listPrimeNumbers(10_000_000);

		final int largest_prime_5 = largestLessThan(100_000);
		final int largest_prime_6 = largestLessThan(1_000_000);
		final int largest_prime_7 = primes.get(primes.size() - 1);
		List<Integer> tetras_preceeding = new ArrayList<Integer>();
		List<Integer> tetras_following = new ArrayList<Integer>();
		int sevens_preceeding = 0;
		int sevens_following = 0;
		int limit = 100_000;

		for ( int prime : primes ) {
		    if ( isTetraPrime(prime - 1) && isTetraPrime(prime - 2) ) {
		        tetras_preceeding.add(prime);
		        if ( ( prime - 1 ) % 7 == 0 || ( prime - 2 ) % 7 == 0 ) {
		        	sevens_preceeding += 1;
		        }
		    }

		    if ( isTetraPrime(prime + 1) && isTetraPrime(prime + 2) ) {
		        tetras_following.add(prime);
		        if ( ( prime + 1 ) % 7 == 0 || ( prime + 2 ) % 7 == 0 ) {
		        	sevens_following += 1;
		        }
		    }

		    if ( prime == largest_prime_5 || prime == largest_prime_6 || prime == largest_prime_7 ) {
		        for ( int i = 0; i <= 1; i++ ) {
		            List<Integer> tetras = ( i == 0 ) ?
		            	new ArrayList<Integer>(tetras_preceeding) : new ArrayList<Integer>(tetras_following);
		            final int size = tetras.size();
		            final int sevens = ( i == 0 ) ? sevens_preceeding : sevens_following;
		            final String text = ( i == 0 ) ? "preceding" : "following";

		            System.out.print("Found " + size + " primes under " + limit + " whose "
		            	+ text + " neighboring pair are tetraprimes");
		            if ( prime == largest_prime_5 ) {
		                System.out.println(":");
		                for ( int j = 0; j < size; j++ ) {
		                	System.out.print(String.format("%7d%s", tetras.get(j), ( j % 10 == 9 ) ? "\n" : "" ));
		                }
		                System.out.println();
		            }
		            System.out.println();
		            System.out.println("of which " + sevens + " have a neighboring pair one of whose factors is 7.");
		            System.out.println();

		            List<Integer> gaps = new ArrayList<Integer>(size - 1);
		            for ( int k = 0; k < size - 1; k++ ) {
		            	gaps.add(tetras.get(k + 1) - tetras.get(k));
		            }
		            Collections.sort(gaps);
		            final int minimum = gaps.get(0);
		            final int maximum = gaps.get(gaps.size() - 1);
		            final int middle = median(gaps);
		            System.out.println("Minimum gap between those " + size + " primes: " + minimum);
		            System.out.println("Median  gap between those " + size + " primes: " + middle);
		            System.out.println("Maximum gap between those " + size + " primes: " + maximum);
		            System.out.println();
		        }
		        limit *= 10;
		    }
		}
	}
	
	private static boolean isTetraPrime(int aNumber) {
	    int count = 0;
	    int previousFactor = 1;
	    for ( int prime : primes ) {
	        int limit = prime * prime;
	        if ( count == 0 ) {
	            limit *= limit;
	        } else if ( count == 1 ) {
	            limit *= prime;
	        }
	        if ( limit <= aNumber ) {
	            while ( aNumber % prime == 0 ) {
	                if ( count == 4 || prime == previousFactor ) {
	                	return false;
	                }
	                count += 1;
	                aNumber /= prime;
	                previousFactor = prime;
	            }
	        } else {
	            break;
	        }
	    }

	    if ( aNumber > 1 ) {
	        if ( count == 4 || aNumber == previousFactor ) {
	        	return false;
	        }
	        count += 1;
	    }
	    return count == 4;
	}
	
	private static int median(List<Integer> aList) {
		if ( aList.size() % 2 == 0 ) {
			return ( aList.get(aList.size() / 2 - 1) + aList.get(aList.size() / 2) ) / 2;
		}
		return aList.get(aList.size() / 2);
	}
	
	private static int largestLessThan(int aNumber) {
		final int index = Collections.binarySearch(primes, aNumber);
		if ( index > 0 ) {
			return primes.get(index - 1);
		}
		return primes.get(-index - 2);
	}
	
	private static void listPrimeNumbers(int aLimit) {
		final int halfLimit = ( aLimit + 1 ) / 2;
		boolean[] composite = new boolean[halfLimit];
		for ( int i = 1, p = 3; i < halfLimit; p += 2, i++ ) {
			if ( ! composite[i] ) {
				for ( int j = i + p; j < halfLimit; j += p ) {
					composite[j] = true;
				}
			}
		}
		
		primes = new ArrayList<Integer>();
		primes.add(2);
		for ( int i = 1, p = 3; i < halfLimit; p += 2, i++ ) {
			if ( ! composite[i] ) {
				primes.add(p);
			}
		}
	}
	
	private static List<Integer> primes;

}
