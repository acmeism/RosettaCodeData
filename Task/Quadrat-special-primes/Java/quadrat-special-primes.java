public final class QuadratSpecialPrimes {

	public static void main(String[] args) {		
	    int i = 1;
	    int prime = 2;
	    System.out.print(prime + " ");
	    while ( true ) {
	        while ( ! isPrime(prime + i * i) ) {
	            i += 1;
	        }
	        prime += i * i;
	        if ( prime > 16_000 ) {
	            break;
	        }
	        System.out.print(prime + " ");
	        i = 1;
	    }
	    System.out.println();
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
