import java.util.function.Predicate;
import java.util.stream.IntStream;

public final class PrimeTriplets {

	public static void main(String[] args) {
		Predicate<Integer> isPrime = p -> IntStream.rangeClosed(2, (int) Math.sqrt(p)).allMatch( i -> p % i != 0 );	
		
		IntStream.range(3, 5500).filter( i -> isPrime.test(i) && isPrime.test(i + 2) && isPrime.test(i + 6) )
		         .forEach( i -> System.out.println("[" + i +", " + ( i + 2 ) + ", " + ( i + 6 ) + "]") );
	}
	
}
