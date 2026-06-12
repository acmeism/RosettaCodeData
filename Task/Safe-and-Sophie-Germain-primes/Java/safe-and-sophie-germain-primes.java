import java.util.function.Predicate;
import java.util.stream.IntStream;

public final class SafeAndSophieGermainPrimes {

	public static void main(String[] args) {
		Predicate<Integer> isPrime = n -> IntStream.rangeClosed(2, (int) Math.sqrt(n) ).allMatch( i -> n % i != 0 );
			
		Predicate<Integer> isSophieGermain = n -> isPrime.test(n) && isPrime.test(2 * n + 1);
		
		System.out.println("The first 50 Sophie Germain primes:");
		int number = 1;
		for ( int count = 0; count < 50; ++count ) {
			do {
				number += 1;
			} while ( ! isSophieGermain.test(number) );
			
			System.out.print(String.format("%4d%s", number, ( count % 10 == 9 ? "\n" : " " )));
		}
		System.out.println();
	}

}
