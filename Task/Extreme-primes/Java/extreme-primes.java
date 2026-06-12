import java.math.BigInteger;
import java.util.List;
import java.util.stream.Collectors;
import java.util.stream.Stream;

public final class ExtremePrimes {

	public static void main(String[] args) {
		List<Long> extremePrimes = Stream.of( 2L ).collect(Collectors.toList());
		long sum = 2;
		int prime = 3;
		int count = 1;
		
		while ( count < 5_000 ) {
		    sum += prime;
		    if ( isPrime(sum) ) {
		        count += 1;
		        if ( count <= 30 ) {
		            extremePrimes.addLast(sum);
		        }	
		
			    if ( count == 30 ) {
		            System.out.println("The first 30 extreme primes are:");
		            for ( int i = 0; i < extremePrimes.size(); i++ ) {
		            	System.out.print(String.format("%7d%s",
		            		extremePrimes.get(i), ( i % 6 == 5 ? "\n" : " " )));
		            }
		            System.out.println();
		        } else if ( count % 1_000 == 0 ) {
		            System.out.println(String.format("%s%12d%s%8d",
		            	"The " + count + "th extreme prime is", sum, " for prime <=", prime));
		        }
		    }
		    prime = nextPrime(prime);
		}
	}
	
	private static boolean isPrime(long candidiate) {
		return BigInteger.valueOf(candidiate).isProbablePrime(15);
	}
	
	private static int nextPrime(int prime) {
		return BigInteger.valueOf(prime).nextProbablePrime().intValueExact();
	}

}
