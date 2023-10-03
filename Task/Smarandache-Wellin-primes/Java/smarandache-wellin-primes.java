import java.math.BigInteger;
import java.util.Arrays;
import java.util.List;
import java.util.stream.Collectors;
import java.util.stream.Stream;

public final class SmarandacheWellinPrimes {

	public static void main(String[] args) {
		primes = listPrimesUpTo(12_000);
		smarandacheWellinPrimes();
		System.out.println();
		derivedSmarandacheWellinPrimes();
	}
	
	private static void smarandacheWellinPrimes() {
		int count = 0;
		int index = 1;
		int number = 2;
		String numberString = "2";
		System.out.println("The first eight Smarandache-Wellin primes are:");
		
		while ( count < 8 ) {
			if ( new BigInteger(numberString).isProbablePrime(CERTAINTY_LEVEL) ) {
				count += 1;
				System.out.println(String.format("%2d%s%-4d%s%-5d%s%d", count, ":  index = ", index,
					"  last prime = ", number, "  number of digits = ", numberString.length()));
			}			
			
			number = primes.get(index);
			numberString += number;
			index += 1;
		}
	}
	
	private static void derivedSmarandacheWellinPrimes() {		
 		int count = 0;
		int index = 0;
		int[] digitFrequencies = new int[10];
		System.out.println("The first 20 derived Smarandache-Wellin numbers which are prime:");
		
		while ( count < 20 ) {
			String prime = String.valueOf(primes.get(index));
			for ( char ch : prime.toCharArray() ) {
				digitFrequencies[ch - '0'] += 1;
			}
			
			index += 1;
			String joined = Arrays.stream(digitFrequencies).mapToObj(String::valueOf).collect(Collectors.joining(""));
			if ( new BigInteger(joined).isProbablePrime(CERTAINTY_LEVEL) ) {
				count += 1;
				System.out.println(String.format("%2d%s%-4d%s%s", count, ":  index = ", index, "  prime = ", joined));
			}
		}
	}
	
	private static List<Integer> listPrimesUpTo(int limit) {
		final int halfLimit = ( limit + 1 ) / 2;
		boolean[] composite = new boolean[halfLimit];
		for ( int i = 1, p = 3; i < halfLimit; p += 2, i++ ) {
			if ( ! composite[i] ) {
				for ( int a = i + p; a < halfLimit; a += p ) {
					composite[a] = true;
				}
			}
		}
		
		List<Integer> result = Stream.of(2).limit(1).collect(Collectors.toList());
		for ( int i = 1, p = 3; i < halfLimit; p += 2, i++ ) {
			if ( ! composite[i] ) {
				result.add(p);
			}
		}
		return result;
	}
	
	private static List<Integer> primes;
	
	private static final int CERTAINTY_LEVEL = 15;
	
}
