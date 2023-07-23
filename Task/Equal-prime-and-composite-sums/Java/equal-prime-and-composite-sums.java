import java.util.BitSet;
import java.util.Objects;

public final class EqualPrimeAndCompositeSums {

	public static void main(String[] aArgs) {		
	    PrimeIterator primeIterator = new PrimeIterator();
	    CompositeIterator compositeIterator = new CompositeIterator();
	    long primeSum = primeIterator.next();
	    long compositeSum = compositeIterator.next();
	    int primeIndex = 1;
	    int compositeIndex = 1;
	
	    System.out.println("Sum           | Prime Index  | Composite Index");
	    System.out.println("----------------------------------------------");
	    int count = 0;
	    while ( count < 8 ) {
	        if ( primeSum == compositeSum ) {
	        	System.out.println(String.format("%13d%s%12d%s%15d",
	        		primeSum, " | ", primeIndex, " | ", compositeIndex));
	        	
	        	primeSum += primeIterator.next();
	            primeIndex += 1;	
	            compositeSum += compositeIterator.next();
	            compositeIndex += 1;	
	            count += 1;
	        } else if ( primeSum < compositeSum ) {
	            primeSum += primeIterator.next();
	            primeIndex += 1;
	        } else {
	            compositeSum += compositeIterator.next();
	            compositeIndex += 1;
	        }
	    }
	}	
	
	private static class CompositeIterator {
		
		public CompositeIterator() {
			primeIterator = new PrimeIterator();
			prime = primeIterator.next();
			composite = prime;
			while ( composite == prime ) {
				prime = primeIterator.next();
				composite += 1;
			}
		}
		
		public int next() {
		    final int result = composite;
		    while ( ++composite == prime ) {
		        prime = primeIterator.next();
		    }
		    return result;
		}
		
		public int prime, composite;
		private PrimeIterator primeIterator;
		
	}
	
	private static class PrimeIterator {
		
		public PrimeIterator() {
			if ( Objects.isNull(sieve) ) {
				listPrimeNumbers(10_000_000);
			}			
		}
		
		public int next() {
			if ( lastPrime < sieve.cardinality() ) {
				lastPrime = sieve.nextSetBit(lastPrime + 1);
			} else {
				do {
					lastPrime += 2;
				}
				while ( ! isPrime(lastPrime) );				
			}			
			return lastPrime;
		}
		
		private static boolean isPrime(int aCandidate) {
			for ( int i = 2; i <= Math.sqrt(aCandidate); i = sieve.nextSetBit(i + 1) ) {
				if ( aCandidate % i == 0 ) {
					return false;
				}
			}
			return true;
		}
		
		private static void listPrimeNumbers(int aN) {
			sieve = new BitSet(aN + 1);
			sieve.set(2, aN + 1);
			for ( int i = 2; i <= Math.sqrt(aN); i = sieve.nextSetBit(i + 1) ) {
				for ( int j = i * i; j <= aN; j = j + i ) {
					sieve.clear(j);
				}
			}
		}
		
		private int lastPrime;
		private static BitSet sieve;		
		
	}	

}
