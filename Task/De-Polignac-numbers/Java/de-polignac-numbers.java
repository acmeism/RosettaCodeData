public final class DePolignacNumbers {

	public static void main(String[] args) {
	    System.out.println("The first 50 de Polignac numbers:");
	    for ( int n = 1, count = 0; count < 10_000; n += 2 ) {
	        if ( isDePolignacNumber(n) ) {
	            count += 1;
	            if ( count <= 50 ) {
	                System.out.print(String.format("%5d%s", n, ( count % 10 == 0 ? "\n" : " ") ));
	            } else if ( count == 1_000 ) {
	            	System.out.println();
	                System.out.println("The 1,000th de Polignac number: " + n);
	            } else if ( count == 10_000 ) {
	            	System.out.println();
	                System.out.println("The 10,000th de Polignac number: " + n);
	            }
	        }
	    }
	}
	
	private static boolean isDePolignacNumber(int number) {
	    for ( int p = 1; p < number; p <<= 1 ) {
	        if ( isPrime(number - p) ) {
	            return false;
	        }
	    }
	    return true;
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
		
		int delta = 2;
		int k = 5;
		while ( k * k <= number ) {
		    if ( number % k == 0 ) {
		    	return false;
		    }
		    k += delta;
		    delta = 6 - delta;
		}
		return true;
	}
	
}
