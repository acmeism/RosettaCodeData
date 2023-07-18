import java.util.ArrayList;
import java.util.Collections;
import java.util.List;

public final class DescendingPrimes {

	public static void main(String[] aArgs) {
		List<Integer> allNumbersStrictlyDescendingDigits = new ArrayList<Integer>(512);
		for ( int i = 0; i < 512; i++ ) {
		    int number = 0;
		    int temp = i;
		    int digit = 9;
		    while ( temp > 0 ) {
		        if ( temp % 2 == 1 ) {
		        	number = number * 10 + digit;
		        }
		        temp >>= 1;
		        digit -= 1;
		    }
		    allNumbersStrictlyDescendingDigits.add(number);
		}

		Collections.sort(allNumbersStrictlyDescendingDigits);
		
		int count = 0;
		for ( int number : allNumbersStrictlyDescendingDigits ) {
		    if ( isPrime(number) ) {
		        System.out.print(String.format("%9d%s", number, ( ++count % 10 == 0 ? "\n" : " " )));
		    }
		}
		System.out.println(System.lineSeparator());
		System.out.println("There are " + count + " descending primes.");	
	}
	
	private static boolean isPrime(int aNumber) {
	    if ( aNumber < 2 || ( aNumber % 2 ) == 0 ) {
	    	return aNumber == 2;
	    }
	
	    for ( int divisor = 3; divisor * divisor <= aNumber; divisor += 2 ) {
	    	if ( aNumber % divisor == 0 ) {
	    		return false;
	    	}
	    }
	    return true;
	}

}
