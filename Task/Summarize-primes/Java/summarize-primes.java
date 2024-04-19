public final class SummarizePrimes {

	public static void main(String[] args) {
		final int start = 1;
	    final int finish = 1_000;

	    int sum = 0;
	    int count = 0;
	    int summarizedCount = 0;

	    for ( int p = start; p < finish; p++ ) {
	        if ( isPrime(p) ) {
	            count += 1;
	            sum += p;
	
	            if ( isPrime(sum) ) {
	            	String word = ( count == 1 ) ? " prime" : " primes";
	                System.out.println(
	                	"The sum of " + count + word + " in [2, " + p + "] is " + sum + ", which is also prime.");
	                summarizedCount++;
	            }
	        }
	    }
	
	    System.out.println(System.lineSeparator() +
	    	"There are " + summarizedCount + " summarized primes in [" + start + ", " + finish + "].");
	}
	
	private static boolean isPrime(int number) {
		if ( number < 2 ) {
	        return false;
	    }
		
	    if ( number % 2 == 0 ) {
	        return number == 2;
	    }
	
	    if ( number % 3 == 0 ) {
	        return number == 3;
	    }

	    int test = 5;
	    while ( test * test <= number ) {
	        if ( number % test == 0 ) {
	            return false;
	        }
	
	        test += 2;	
	        if ( number % test == 0 ) {
	            return false;
	        }
	
	        test += 4;
	    }
	
		return true;
	}

}
