import java.util.ArrayList;
import java.util.List;
import java.util.stream.Collectors;
import java.util.stream.IntStream;

public final class RadicalOfAnInteger {

	public static void main(String[] aArgs) {
		sievePrimes();
		distinctPrimeFactors();
		
		System.out.println("Radical of first 50 positive integers:");
		for ( int n = 1; n <= 50; n++ ) {
			System.out.print(String.format("%3d%s", radical(n), ( n % 10 == 0 ? "\n" : "" )));
		}
		System.out.println();
		
		for ( int n : List.of( 99_999, 499_999, 999_999 ) ) {
			System.out.println(String.format("%s%7d%s%7d", "Radical for ", n, ":", radical(n)));
		}
		System.out.println();
		
		System.out.print("Distribution of the first one million positive ");
		System.out.println("integers by numbers of distinct prime factors:");
		List<Integer> counts = IntStream.rangeClosed(0, 7).boxed().map( i -> 0 ).collect(Collectors.toList());
		for ( int n = 1; n <= LIMIT; n++ ) {
			counts.set(distinctPrimeFactorCount(n), counts.get(distinctPrimeFactorCount(n)) + 1);
		}		
		for ( int n = 0; n < counts.size(); n++ ) {
			System.out.println(String.format("%d%s%7d", n, ":", counts.get(n)));
		}
		System.out.println();
		
		System.out.println("Number of primes and powers of primes less than or equal to one million:");
		int count = 0;
		final double logOfLimit = Math.log(LIMIT);
		for ( int p : primes ) {
		    count += logOfLimit / Math.log(p);
		}
		System.out.println(count);
	}
	
	private static int radical(int aNumber) {
		return distinctPrimeFactors.get(aNumber).stream().reduce(1, Math::multiplyExact);
	}
	
	private static int distinctPrimeFactorCount(int aNumber) {
		return distinctPrimeFactors.get(aNumber).size();
	}
	
	private static void distinctPrimeFactors() {
		distinctPrimeFactors = IntStream.rangeClosed(0, LIMIT).boxed()
			.map( i -> new ArrayList<Integer>() ).collect(Collectors.toList());
		for ( int p : primes ) {
		    for ( int n = p; n <= LIMIT; n += p ) {
			    distinctPrimeFactors.get(n).add(p);
		    }
		}
	}
	
	private static void sievePrimes() {
		List<Boolean> markedPrime = IntStream.rangeClosed(0, LIMIT).boxed()
			.map( i -> true ).collect(Collectors.toList());
        for ( int p = 2; p * p <= LIMIT; p++ ) {
            if ( markedPrime.get(p) ) {
                for ( int i = p * p; i <= LIMIT; i += p ) {
                    markedPrime.set(i, false);
                }
            }
        }

        primes = new ArrayList<Integer>();
        for ( int p = 2; p <= LIMIT; p++ ) {
            if ( markedPrime.get(p) ) {
                primes.add(p);
            }
        }
    }

	private static List<Integer> primes;
	private static List<List<Integer>> distinctPrimeFactors;
	
	private static final int LIMIT = 1_000_000;

}
