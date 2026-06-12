import java.util.List;
import java.util.function.IntFunction;
import java.util.function.IntPredicate;
import java.util.stream.IntStream;

public class PrimesWhichContainOnlyOneOddDigit {

	public static void main(String[] args) {
		IntFunction<IntPredicate> sieve = n -> i -> i == n || i % n != 0;
		
		IntStream primes = IntStream.range(2, 1_000_000).filter(sieve.apply(2));
		for ( int i = 3; i * i <= 1_000_000; i += 2 ) {
	        primes = primes.filter(sieve.apply(i));
		}
		
		IntPredicate hasOneOddDigit = n ->
			String.valueOf(n).chars().map( ch -> ch + '0' ).filter( i -> i % 2 == 1 ).count() == 1;
		
		List<Integer> oneOddDigitPrimes = primes.filter( p -> hasOneOddDigit.test(p) ).boxed().toList();
		
		System.out.println("Primes less than 1,000 with only one odd digit:");
		oneOddDigitPrimes.stream().takeWhile( i -> i < 1_000 ).forEach( i -> System.out.print(i + " ") );
	
		System.out.println("\n\nThe number of such primes less than 1,000,000 is " + oneOddDigitPrimes.size());
	}

}
