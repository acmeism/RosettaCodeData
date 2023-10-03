import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;

public final class SisyphusSequence {

	public static void main(String[] args) {
		final long limit = 100_000_000;
		SisyphusIterator iterator = new SisyphusIterator(1_000_000_000_000L);		
	    System.out.println("The first 100 members of the Sisyphus sequence are:");
	    int[] found = new int[250];
	    long next = 0;
	    long count = 0;
	    int target = 1_000;

	    while ( target <= limit ) {
	    	count += 1;
	        next = iterator.next();
	        if ( next < 250 ) {
	            found[(int) next]++;
	        }
	        if ( count <= 100 ) {
	            System.out.print(String.format("%3d%s", next, ( count % 10 == 0 ? "\n" : " ")));
	            if ( count == 100 ) {
	                System.out.println();
	            }
	        } else if ( count == target ) {
	        	target *= 10;
	        	System.out.println(String.format("%11d%s%11d%s%10d",
	        		target, "th member is ", next, " and highest prime needed is ", iterator.getPrime()));
	        }
	    }
	
	    display(found, 0, target, "These numbers under 250 occur the most in the first ", "");
	
	    final int max = Arrays.stream(found).max().orElseThrow();
	    display(found, max, target,
	    	"These numbers under 250 occur the most in the first ", "all occur " + max + " times");	
	
	    while ( next != 36 ) {
	    	count += 1;
	    	next = iterator.next();
	    }
	    System.out.println();
	    System.out.println(count + "th member is " + next + " and highest prime needed is " + iterator.getPrime());
	}
	
	private static void display(int[] found, int search, int target, String prefix, String suffix) {
		System.out.println();
		System.out.println(prefix + target + " terms:");
		for ( int i = 1; i < found.length; i++ ) {
	    	if ( found[i] == search ) {
	    		System.out.print(i + "  ");
	    	}
	    }
		System.out.println(suffix);	
	}

}

final class SisyphusIterator {
	
	public SisyphusIterator(long limit) {
		previous = 2;
		prime = 0;
		primeIterator = new SegmentedPrimeIterator(limit);
	}

	public long next() {
        if ( ( previous & 1 ) == 0 ) {
            previous >>= 1;
        } else {
        	prime = primeIterator.next();
            previous += prime;
        }
        return previous;
    }
	
	public long getPrime() {
		return prime;
	}

	private long previous;
	private long prime;
	private SegmentedPrimeIterator primeIterator;

}

final class SegmentedPrimeIterator {
	
	public SegmentedPrimeIterator(long limit) {
		squareRoot = (int) Math.sqrt(limit);	
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

    private void smallSieve(int squareRoot) {
        boolean[] markedPrime = new boolean[squareRoot + 1];
        Arrays.fill(markedPrime, true);

        for ( int p = 2; p * p <= squareRoot; p++ ) {
            if ( markedPrime[p] ) {
                for ( int i = p * p; i <= squareRoot; i += p ) {
                    markedPrime[i] = false;
                }
            }
        }

        for ( int p = 2; p <= squareRoot; p++ ) {
            if ( markedPrime[p] ) {
                primes.add((long) p);
            }
        }
        smallPrimes.addAll(primes);
    }

    private int index, squareRoot;
    private long low, high;
    private List<Long> primes = new ArrayList<Long>();
    private List<Long> smallPrimes = new ArrayList<Long>();	

}
