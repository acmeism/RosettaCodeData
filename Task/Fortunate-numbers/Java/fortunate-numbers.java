import java.math.BigInteger;
import java.util.BitSet;
import java.util.NavigableSet;
import java.util.TreeSet;

public final class FortunateNumbers {

	public static void main(String[] aArgs) {
		BitSet primes = primeSieve(400);		
		NavigableSet<Integer> fortunates = new TreeSet<Integer>();
        BigInteger primorial = BigInteger.ONE;
		
		for ( int prime = 2; prime >= 0; prime = primes.nextSetBit(prime + 1) ) {
		    primorial = primorial.multiply(BigInteger.valueOf(prime));
		    int candidate = 3;
		    while ( ! primorial.add(BigInteger.valueOf(candidate)).isProbablePrime(CERTAINTY_LEVEL) ) {
		    	candidate += 2;
		    }
		    fortunates.add(candidate);
		}
		
		System.out.println("The first 50 distinct fortunate numbers are:");
		for ( int i = 0; i < 50; i++ ) {
			System.out.print(String.format("%4d%s", fortunates.pollFirst(), ( i % 10 == 9 ? "\n" : "" )));
		}
	}
	
	private static BitSet primeSieve(int aNumber) {
		BitSet sieve = new BitSet(aNumber + 1);
		sieve.set(2, aNumber + 1);
		for ( int i = 2; i <= Math.sqrt(aNumber); i = sieve.nextSetBit(i + 1) ) {
			for ( int j = i * i; j <= aNumber; j = j + i ) {
				sieve.clear(j);
			}
		}		
		return sieve;
	}
	
	private static final int CERTAINTY_LEVEL = 10;

}
