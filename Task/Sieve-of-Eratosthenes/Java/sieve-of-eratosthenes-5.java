import java.util.Iterator;
import java.util.PriorityQueue;
import java.math.BigInteger;

// generates all prime numbers
public class InfiniteSieve implements Iterator<BigInteger> {

    private static class NonPrimeSequence implements Comparable<NonPrimeSequence> {
	BigInteger currentMultiple;
	BigInteger prime;

	public NonPrimeSequence(BigInteger p) {
	    prime = p;
	    currentMultiple = p.multiply(p); // start at square of prime
	}
	@Override public int compareTo(NonPrimeSequence other) {
	    // sorted by value of current multiple
	    return currentMultiple.compareTo(other.currentMultiple);
	}
    }

    private BigInteger i = BigInteger.valueOf(2);
    // priority queue of the sequences of non-primes
    // the priority queue allows us to get the "next" non-prime quickly
    final PriorityQueue<NonPrimeSequence> nonprimes = new PriorityQueue<NonPrimeSequence>();

    @Override public boolean hasNext() { return true; }
    @Override public BigInteger next() {
	// skip non-prime numbers
	for ( ; !nonprimes.isEmpty() && i.equals(nonprimes.peek().currentMultiple); i = i.add(BigInteger.ONE)) {
            // for each sequence that generates this number,
            // have it go to the next number (simply add the prime)
            // and re-position it in the priority queue
	    while (nonprimes.peek().currentMultiple.equals(i)) {
		NonPrimeSequence x = nonprimes.poll();
		x.currentMultiple = x.currentMultiple.add(x.prime);
		nonprimes.offer(x);
	    }
	}
	// prime
        // insert a NonPrimeSequence object into the priority queue
	nonprimes.offer(new NonPrimeSequence(i));
	BigInteger result = i;
	i = i.add(BigInteger.ONE);
	return result;
    }

    public static void main(String[] args) {
	Iterator<BigInteger> sieve = new InfiniteSieve();
	for (int i = 0; i < 25; i++) {
	    System.out.println(sieve.next());
	}
    }
}
