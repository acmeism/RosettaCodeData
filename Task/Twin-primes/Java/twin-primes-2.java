import java.util.BitSet;

public final class TwinPrimes {

	public static void main(String[] args) {
		final int limit = 1_000_000_000;
		sievePrimes(limit);
		
		int target = 10;
		int count = 0;
	    boolean last = false;
	    boolean first = true;
	
	    for ( int index = 5; index <= limit; index += 2 ) {
	        last = first;
	        first = primes.get(index);
	        if ( last && first ) {
	            count += 1;
	        }
	        if ( index + 1 == target ) {
	        	System.out.println(String.format("%8d%s%d", count, " twin primes below ", index + 1));
	        	target *= 10;
	        }
	    }		
	}	
	
	private static void sievePrimes(int aLimit) {
		primes = new BitSet(aLimit + 1);
		primes.set(2, aLimit + 1);
		for ( int i = 2; i <= Math.sqrt(aLimit); i = primes.nextSetBit(i + 1) ) {
			for ( int j = i * i; j <= aLimit; j += i ) {
				primes.clear(j);
			}
		}		
	}
	
	private static BitSet primes;	

}
