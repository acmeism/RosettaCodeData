import java.util.stream.IntStream;

public final class TwinPrimesWhoseSumIsSquareNumber {

	public static void main(String[] args) {
		IntStream.range(3, 10_000).filter( i -> isPrime(i) && isPrime(i + 2) ).forEach( p -> {
			final int sum = 2 * p + 2;
	        final int sqrt = (int) Math.sqrt(sum);
	        if ( sum == sqrt * sqrt ) {
	            System.out.println(sqrt + "² = " + p + " + " + ( p + 2 ));
	        }			
		} );		
	}
	
	private static boolean isPrime(int number) {
	    if ( number % 2 == 0 ) {
	    	return number == 2;
	    }
	    int k = 3;
	    while ( k * k <= number ) {
	    	if ( number % k == 0 ) {
	    		return false;
	    	}
	    	k += 2;
	    }
	    return true;
	}
	
}
