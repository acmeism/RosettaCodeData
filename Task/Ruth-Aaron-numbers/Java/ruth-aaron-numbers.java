import java.util.ArrayList;
import java.util.BitSet;
import java.util.Collection;
import java.util.HashSet;
import java.util.List;

public final class RuthAaronNumbers {
	
	public static void main(String[] aArgs) {		
		System.out.println("The first 30 Ruth-Aaron numbers (factors):");
	    firstRuthAaronNumbers(30, NumberType.FACTOR);
	
	    System.out.println("The first 30 Ruth-Aaron numbers (divisors):");
	    firstRuthAaronNumbers(30, NumberType.DIVISOR);
	
	    System.out.println("First Ruth-Aaron triple (factors): " + firstRuthAaronTriple(NumberType.FACTOR));
		System.out.println();
	
		System.out.println("First Ruth-Aaron triple (divisors): " + firstRuthAaronTriple(NumberType.DIVISOR));
		System.out.println();		
	}
	
	private enum NumberType { DIVISOR, FACTOR }
	
	private static void firstRuthAaronNumbers(int aCount, NumberType aNumberType) {
		primeSumOne = 0;
		primeSumTwo = 0;
		
		for ( int n = 2, count = 0; count < aCount; n++ ) {			
	        primeSumTwo = switch ( aNumberType ) {
	        	case DIVISOR -> primeDivisorSum(n);
	        	case FACTOR -> primeFactorSum(n);
	        };
	
	        if ( primeSumOne == primeSumTwo ) {
	            count += 1;
	            System.out.print(String.format("%6d", n - 1));
	            if ( count == aCount / 2 ) {
	            	System.out.println();
	            }
	        }
	
	        primeSumOne = primeSumTwo;
	    }
		
		System.out.println();
		System.out.println();
	}
	
	private static int firstRuthAaronTriple(NumberType aNumberType) {
		primeSumOne = 0;
		primeSumTwo = 0;
		primeSumThree = 0;
		
		int n = 2;
		boolean found = false;
		while ( ! found ) {
			primeSumThree = switch ( aNumberType ) {
				case DIVISOR -> primeDivisorSum(n);
				case FACTOR -> primeFactorSum(n);
			};
			
			if ( primeSumOne == primeSumTwo && primeSumTwo == primeSumThree ) {
				found = true;
			}
			
			n += 1;			
			primeSumOne = primeSumTwo;
			primeSumTwo = primeSumThree;			
		}
		
		return n - 2;
	}
	
	private static int primeDivisorSum(int aNumber) {
		return primeSum(aNumber, new HashSet<Integer>());
	}
	
	private static int primeFactorSum(int aNumber) {
		return primeSum(aNumber, new ArrayList<Integer>());
	}
	
	private static int primeSum(int aNumber, Collection<Integer> aCollection) {
		Collection<Integer> values = aCollection;

		for ( int i = 0, prime = 2; prime * prime <= aNumber; i++ ) {
			while ( aNumber % prime == 0 ) {
				aNumber /= prime;
				values.add(prime);
			}
			prime = primes.get(i + 1);
		}

		if ( aNumber > 1 ) {
			values.add(aNumber);
		}
		
		return values.stream().reduce(0, ( l, r ) -> l + r );
	}
	
	private static List<Integer> listPrimeNumbersUpTo(int aNumber) {
		BitSet sieve = new BitSet(aNumber + 1);
		sieve.set(2, aNumber + 1);
		
		final int squareRoot = (int) Math.sqrt(aNumber);
		for ( int i = 2; i <= squareRoot; i = sieve.nextSetBit(i + 1) ) {
			for ( int j = i * i; j <= aNumber; j += i ) {
				sieve.clear(j);
			}
		}
		
		List<Integer> result = new ArrayList<Integer>(sieve.cardinality());
		for ( int i = 2; i >= 0; i = sieve.nextSetBit(i + 1) ) {
			result.add(i);
		}
		
		return result;
	}
	
	private static int primeSumOne, primeSumTwo, primeSumThree;
	private static List<Integer> primes = listPrimeNumbersUpTo(50_000);

}
