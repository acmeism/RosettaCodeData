import java.util.ArrayList;
import java.util.List;
import java.util.Set;
import java.util.TreeSet;

public final class CalmoNumbers {

	public static void main(String[] args) {
		System.out.print("Calmo numbers less than 1,000:");
		for ( int n = 1; n < 1_000; n++ ) {
			if ( isCalmoNumber(n) ) {
			    System.out.print(" " + n);
			}
		}
		System.out.println();
	}
	
	private static boolean isCalmoNumber(int number) {
	    List<Integer> properDivisors = properDivisors(number);
	    if ( properDivisors.isEmpty() || properDivisors.size() % 3 != 0 ) {
	    	return false;
	    }
	
	    for ( int i = 0; i < properDivisors.size(); i += 3 ) {
	    	if ( ! isPrime(properDivisors.get(i) + properDivisors.get(i + 1) + properDivisors.get(i + 2)) ) {
	    		return false;
	    	}
	    }
	    return true;
	}
	
	private static List<Integer> properDivisors(int number) {
		Set<Integer> properDivisors = new TreeSet<Integer>();
		
	    int divisor = 2;
	    while ( divisor * divisor <= number ) {	    	
	        if ( number % divisor == 0 ) {
	        	properDivisors.add(divisor);
	        	properDivisors.add(number / divisor);
	        }
	        divisor += 1;	
	    }	
	    return new ArrayList<Integer>(properDivisors);
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
