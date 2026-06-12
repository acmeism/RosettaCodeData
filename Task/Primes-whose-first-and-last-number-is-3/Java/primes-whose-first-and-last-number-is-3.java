import java.util.ArrayList;
import java.util.List;

public final class PrimesWhoseFirstAndLastNumberIs3 {

	public static void main(String[] args) {
		List<Integer> primes33 = new ArrayList<Integer>();
		
		for ( int i = 3; i < 1_000_000; i++ ) {
			if ( isPrime(i) ) {
		        String prime = String.valueOf(i);
		        if ( prime.startsWith("3") && prime.endsWith("3") ) {
		        	primes33.addLast(i);
		        }
		    }
			
			if ( i == 4_000 ) {
				System.out.println("There are " + primes33.size()
					+ " primes less than 4,000 that start and end with 3:");
				for ( int j = 0; j < primes33.size(); j++ ) {
					System.out.print(String.format("%4d%s",	primes33.get(j), ( j % 10 == 9 ? "\n" : " " )));
				}
				System.out.println(System.lineSeparator());
			}						
		}
		
		System.out.println("There are " + primes33.size() + " primes less than 1,000,000 that start and end with 3.");	
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
