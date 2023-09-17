import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;

public final class RamanujanPrimesTwins {

	public static void main(String[] aArgs) {
		final int limit = 1_000_000;
		final int[] primePi = initialisePrimePi(ramanujanMaximum(limit) + 1);
		final int millionthRamanujanPrime = ramanujanPrime(primePi, limit);
		System.out.println("The 1_000_000th Ramanujan prime is " + millionthRamanujanPrime);
		
		List<Integer> primes = listPrimesLessThan(millionthRamanujanPrime);		
		int[] ramanujanPrimeIndexes = new int[primes.size()];
		for ( int i = 0; i < ramanujanPrimeIndexes.length; i++ ) {
			ramanujanPrimeIndexes[i] = primePi[primes.get(i)] - primePi[primes.get(i) / 2];
		}
		int lowerLimit = ramanujanPrimeIndexes[ramanujanPrimeIndexes.length - 1];
		for ( int i = ramanujanPrimeIndexes.length - 2; i >= 0; i-- ) {
			if ( ramanujanPrimeIndexes[i] < lowerLimit ) {
				lowerLimit = ramanujanPrimeIndexes[i];
			} else {
				ramanujanPrimeIndexes[i] = 0;
			}
		}
		
		List<Integer> ramanujanPrimes = new ArrayList<Integer>();
		for ( int i = 0; i < ramanujanPrimeIndexes.length; i++ ) {
			if ( ramanujanPrimeIndexes[i] != 0 ) {
				ramanujanPrimes.add(primes.get(i));
			}
		}
		
		int twinsCount = 0;
        for ( int i = 0; i < ramanujanPrimes.size() - 1; i++ ) {
            if ( ramanujanPrimes.get(i) + 2 == ramanujanPrimes.get(i + 1) ) {
                twinsCount += 1;
            }
        }
		System.out.println("There are " + twinsCount + " twins in the first " + limit + " Ramanujan primes.");
	}
	
	private static List<Integer> listPrimesLessThan(int aLimit) {
		boolean[] composite = new boolean[aLimit + 1];
		int n = 3;
		int nSquared = 9;
		while ( nSquared <= aLimit ) {
		    if ( ! composite[n] ) {
		    	for ( int k = nSquared; k < aLimit; k += 2 * n ) {
		    		composite[k] = true;
		    	}
		    }
		    nSquared += ( n + 1 ) << 2;
		    n += 2;
		}
		
		List<Integer> result = new ArrayList<Integer>();
		result.add(2);
		for ( int i = 3; i < aLimit; i += 2 ) {
		    if ( ! composite[i] ) {
		    	result.add(i);
		    }
		}
		return result;
	}

	private static int ramanujanPrime(int[] aPrimePi, int aNumber) {
		int maximum = ramanujanMaximum(aNumber);
		if ( ( maximum & 1) == 1 ) {
			maximum -= 1;
		}
		
		int index = maximum;
		while ( aPrimePi[index] - aPrimePi[index / 2] >= aNumber ) {
			index -= 1;
		}
		return index + 1;
	}
	
	private static int[] initialisePrimePi(int aLimit) {
		int[] result = new int[aLimit];
        Arrays.fill(result, 1);
        result[0] = 0;
        result[1] = 0;
        for ( int i = 4; i < aLimit; i += 2 ) {
            result[i] = 0;
        }
        for ( int p = 3, square = 9; square < aLimit; p += 2 ) {
            if ( result[p] != 0 ) {
                for ( int q = square; q < aLimit; q += p << 1 ) {
                    result[q] = 0;
                }
            }
            square += ( p + 1 ) << 2;
        }
        Arrays.parallelPrefix(result, Integer::sum);
        return result;
    }
	
	private static int ramanujanMaximum(int aNumber) {
		return (int) Math.ceil(4 * aNumber * Math.log(4 * aNumber));
	}

}
