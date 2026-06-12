import java.util.function.Predicate;
import java.util.stream.IntStream;

public final class PrimeNumbersPForWhichTheSumOfPrimesLessThanOrEqualToPIsPrime {

	public static void main(String[] args) {
		Predicate<Integer> isPrime = n -> IntStream.rangeClosed(2, (int) Math.sqrt(n)).allMatch( i -> n % i > 0 );
		
		int sum = 0;
		for ( int i = 2; i < 1_000; i++ ) {
		    if ( isPrime.test(i) ) {
		        sum += i;
		        if ( isPrime.test(sum) ) {
		            System.out.print(i + " ");
		        }
		    }
		}
		System.out.println();
	}

}
