import java.util.ArrayList;
import java.util.Arrays;
import java.util.Collections;
import java.util.List;

public final class OrmistonTriples {

	public static void main(String[] aArgs) {
		final long limit = 10_000_000_000L;
		SegmentedPrimeIterator primes = new SegmentedPrimeIterator(limit);
		List<Long> ormistons = new ArrayList<Long>();
		long lowerLimit = limit / 10;
		int count = 0;
		List<Integer> counts = new ArrayList<Integer>();
		long p1 = 0, p2 = 0, p3 = 0;
		
		while ( p3 < limit ) {
			p1 = p2; p2 = p3; p3 = primes.next();
		
		    if ( ( p2 - p1 ) % 18 != 0 || ( p3 - p2 ) % 18 != 0 ) {
		    	continue;
		    }
	
		    if ( ! haveSameDigits(p1, p2) ) {
		    	continue;
		    }
	
		    if ( haveSameDigits(p2, p3) ) {
		        if ( count < 25 ) {
		        	ormistons.add(p1);
		        }
		        if ( p1 >= lowerLimit ) {
		            counts.add(count);
		            lowerLimit *= 10;
		        }
		        count += 1;
		    }
		}		
		counts.add(count);
		
		System.out.println("The smallest member of the first 25 Ormiston triples:");
		for ( int i = 0; i < ormistons.size(); i++ ) {
			System.out.print(String.format("%10d%s", ormistons.get(i), ( i % 5 == 4 ? "\n" : "" )));
		}
		System.out.println();		
		
		lowerLimit = limit / 10;
		for ( int i = 0; i < counts.size(); i++ ) {
			System.out.println(counts.get(i) + " Ormiston triples less than " + lowerLimit);
		    lowerLimit *= 10;
		}

	}	
 	
	private static boolean haveSameDigits(long aOne, long aTwo) {
		return digits(aOne).equals(digits(aTwo));	
	}
	
	private static List<Integer> digits(long aNumber) {
		List<Integer> result = new ArrayList<Integer>();
		while ( aNumber > 0 ) {
			result.add((int) ( aNumber % 10 ));
			aNumber /= 10;
		}
		Collections.sort(result);
		return result;
	}	

}

final class SegmentedPrimeIterator {
	
	public SegmentedPrimeIterator(long aLimit) {
		squareRoot = (int) Math.sqrt(aLimit);	
        high = squareRoot;
        smallSieve(squareRoot);
	}
	
	public long next() {
		if ( index == primes.size() ) {
			index = 0;
			segmentedSieve();
		}    		
		return primes.get(index++);    		
	}

    private void segmentedSieve() {
        low += squareRoot;
        high += squareRoot;	         	

        boolean[] markedPrime = new boolean[squareRoot];
        Arrays.fill(markedPrime, true);

        for ( int i = 0; i < smallPrimes.size(); i++ ) {
            long lowLimit = ( low / smallPrimes.get(i) ) * smallPrimes.get(i);
            if ( lowLimit < low ) {
                lowLimit += smallPrimes.get(i);
            }

            for ( long j = lowLimit; j < high; j += smallPrimes.get(i) ) {
                markedPrime[(int) ( j - low )] = false;
            }
        }

        primes.clear();
        for ( long i = low; i < high; i++ ) {
            if ( markedPrime[(int) ( i - low )] ) {
            	primes.add(i);
            }
        }
    }

    private void smallSieve(int aSquareRoot) {
        boolean[] markedPrime = new boolean[aSquareRoot + 1];
        Arrays.fill(markedPrime, true);

        for ( int p = 2; p * p <= aSquareRoot; p++ ) {
            if ( markedPrime[p] ) {
                for ( int i = p * p; i <= aSquareRoot; i += p ) {
                    markedPrime[i] = false;
                }
            }
        }

        for ( int p = 2; p <= aSquareRoot; p++ ) {
            if ( markedPrime[p] ) {
                primes.add((long) p);
            }
        }
        smallPrimes.addAll(primes);
    }

    private static int index, squareRoot;
    private static long low, high;
    private static List<Long> primes = new ArrayList<Long>();
    private static List<Long> smallPrimes = new ArrayList<Long>();	

}
