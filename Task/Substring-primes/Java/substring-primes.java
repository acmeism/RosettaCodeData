import module java.base;

public final class SubstringPrimes {

	public static void main() {
		Predicate<Integer> isPrime = n ->
			IntStream.rangeClosed(2, (int) Math.sqrt(n)).noneMatch( i -> n % i == 0 );			
		
		// Begin with 1 digit primes
		List<Integer> primes = Stream.of( 2, 3, 5, 7 ).collect(Collectors.toList());
		List<Integer> composites = new ArrayList<Integer>();
		int testCount = 4; // Tests required to obtain the initial primes		
		
		// Search for 2-digit substring primes
		for ( int prime : new ArrayList<Integer>(primes) ) {
			// Additional digits must be 3 or 7 otherwise a composite substring would exist
		    for ( int digit : List.of( 3, 7 ) ) {
		        // If 'prime' and 'digit' are the same, 'number' would be divisible by 11
		        if ( prime != digit ) {
		            final int number = prime * 10 + digit;
		            if ( isPrime.test(number) ) {
		            	primes.addLast(number);
		            } else {
		            	composites.addLast(number);
		            }		
		            testCount += 1;
		        }
		    }
		}
		
		// Search for 3-digit substring primes
		for ( int prime : new ArrayList<Integer>(primes) ) {
		    for ( int digit : List.of( 3, 7 ) ) {
		    	// Only test two digit 'primes'
		        // If the last digit of 'prime' and 'digit' are the same, 'number' would be divisible by 11
		        if ( 10 < prime && prime < 100 && prime % 10 != digit ) {
		            final int number = prime * 10 + digit;
		            if ( isPrime.test(number) ) {
		            	primes.addLast(number);
		            } else {
		            	composites.add(number);
		            }		
		            testCount += 1;
		        }
		    }
		}		
	
		IO.println("There are %d primes where all substrings are also primes, namely: %s"
			.formatted(primes.size(), primes));
		IO.println("\nThe following numbers were tested for primality, but found to be composite: " + composites);
		IO.println("\nTotal number of primality tests: " + testCount);
	}

}
