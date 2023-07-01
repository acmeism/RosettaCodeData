import java.util.ArrayList;
import java.util.Collections;
import java.util.List;

public final class GiugaNumbers {
	
	public static void main(String[] aArgs) {
        primes = List.of( 2, 3, 5, 7, 11, 13, 17, 19, 23, 29, 31, 37, 41, 43, 47, 53, 59 );

        List<Integer> primeCounts = List.of( 3, 4, 5 );
        for ( int primeCount : primeCounts ) {
        	primeFactors = new ArrayList<Integer>(Collections.nCopies(primeCount, 0));
        	combinations(primeCount, 0, 0);
        }

        Collections.sort(results);
        System.out.println("Found Giuga numbers: " + results);
    }
	
	private static void checkIfGiugaNumber(List<Integer> aPrimeFactors) {
		final int product = aPrimeFactors.stream().reduce(1, Math::multiplyExact);
		
		for ( int factor : aPrimeFactors ) {
			final int divisor = factor * factor;
			if ( ( product - factor ) % divisor != 0 ) {
				return;
			}
		}
		
		results.add(product);		
	}

    private static void combinations(int aPrimeCount, int aIndex, int aLevel) {
        if ( aLevel == aPrimeCount ) {
        	checkIfGiugaNumber(primeFactors);
            return;
        }

        for ( int i = aIndex; i < primes.size(); i++ ) {
            primeFactors.set(aLevel, primes.get(i));
            combinations(aPrimeCount, i + 1, aLevel + 1);
        }
    }

    private static List<Integer> primes;
    private static List<Integer> primeFactors;
    private static List<Integer> results = new ArrayList<Integer>();

}
