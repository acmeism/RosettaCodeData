import java.util.ArrayList;
import java.util.List;
import java.util.TreeSet;
import java.util.stream.Collectors;

public final class NumbersWhoseCountOfDivisorsIsPrime {

	public static void main(String[] args) {
		List<Integer> primes = listPrimeNumbers((int) Math.sqrt(100_000));	
		
		primes.stream().flatMap( p -> primes.stream().skip(1).map( i -> (int) Math.pow(p, i - 1) ))
			           .filter( i -> i < 100_000)
			           .collect(Collectors.toCollection(TreeSet::new))
			           .forEach( i -> System.out.print(i + " ") );
	}
	
	private static List<Integer> listPrimeNumbers(int maximum) {
		final int halfMaximum = ( maximum + 1 ) / 2;
		boolean[] composite = new boolean[halfMaximum];
		for ( int i = 1, p = 3; i < halfMaximum; p += 2, i++ ) {
			if ( ! composite[i] ) {
				for ( int j = i + p; j < halfMaximum; j += p ) {
					composite[j] = true;
				}
			}
		}
		
		List<Integer> primes = new ArrayList<Integer>(List.of( 2 ));
		for ( int i = 1, p = 3; i < halfMaximum; p += 2, i++ ) {
			if ( ! composite[i] ) {
				primes.add(p);
			}
		}
		return primes;
	}

}
