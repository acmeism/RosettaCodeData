import java.util.ArrayList;
import java.util.List;

public final class OrmistonPairs {

	public static void main(String[] args) {
		List<Integer> primes = listPrimeNumbers(10_000_000);
		List<Integer> ormistonIndexes = new ArrayList<Integer>();
		int upperCount = 0;
		int lowerCount = 0;
		for ( int i = 0; i < primes.size() - 1; i++ ) {
			final int prime1 = primes.get(i);
			final int prime2 = primes.get(i + 1);
			if ( ( prime2 - prime1 ) % 18 != 0 ) {
				continue;
			}
			
			if ( digits(prime2).equals(digits(prime1)) ) {
				if ( upperCount < 30 ) {
					ormistonIndexes.addLast(i);
				}
				upperCount += 1;
				
				if ( prime2 < 1_000_000 ) {
					lowerCount += 1;
				}
			}
		}
		
		System.out.println("The first 30 Ormiston pairs are:");
		for ( int i = 0; i < 30; i++ ) {
			final int index = ormistonIndexes.get(i);
			System.out.print(String.format("%s%5d%s%5d%s%s",
				"(", primes.get(index), ", ", primes.get(index + 1), ")", ( i % 6 == 5 ? "\n" : " " )));
		}
		System.out.println();
		
		System.out.println("There are " + lowerCount + " Ormiston pairs less than 1,000,000");
		System.out.println("There are " + upperCount + " Ormiston pairs less than 10,000,000");
	}
	
	private static List<Integer> digits(int number) {
		List<Integer> digits = new ArrayList<Integer>(ZEROS);
		while ( number > 0 ) {
			final int digit = number % 10;
			digits.set(digit, digits.get(digit) + 1);
		    number /= 10;		
		}		
		return digits;
	}
	
	private static List<Integer> listPrimeNumbers(int limit) {
		List<Integer> primes = new ArrayList<Integer>();
		primes.add(2);
		final int halfLimit = ( limit + 1 ) / 2;
		boolean[] composite = new boolean[halfLimit];
		for ( int i = 1, p = 3; i < halfLimit; p += 2, i++ ) {
			if ( ! composite[i] ) {
				primes.addLast(p);
				for ( int a = i + p; a < halfLimit; a += p ) {
					composite[a] = true;
				}
			}
		}
		return primes;
	}	
	
	private static final List<Integer> ZEROS = List.of( 0, 0, 0, 0, 0, 0, 0, 0, 0, 0 );

}
