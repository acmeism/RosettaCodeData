import java.util.ArrayList;
import java.util.List;

public final class CarmichaelLambdaFunction {

	public static void main(String[] args) {
		System.out.println(" n   carmichael(n) iterations(n)");
		System.out.println("--------------------------------");
		for ( int i = 1; i <= 25; i++ ) {
		    System.out.println(String.format("%2d%10d%14d", i, carmichaelLambda(i), countIterationsToOne(i)));
		}
		System.out.println();
		
		System.out.println("Iterations to 1     n     lambda(n)");
		System.out.println("-----------------------------------");
		int n = 1;
		for ( int i = 0; i <= 15; i++ ) {
		    while ( countIterationsToOne(n) != i ) {
		        n += 1;
		    }
		    System.out.println(String.format("%2d%19s%13s", i, n, carmichaelLambda(n)));
		}
	}
	
	private static int countIterationsToOne(int n) {
		return ( n <= 1 ) ? 0 : countIterationsToOne(carmichaelLambda(n)) + 1;
	}
	
	private static int carmichaelLambda(int number) {
	    if ( number == 1 ) {
	    	return 1;
	    }
	
	    List<PrimePower> powers = primePowers(number);
	    int result = 1;	
	    for ( PrimePower primePower : powers ) {
	    	 int car = ( primePower.prime - 1 ) * (int) Math.pow(primePower.prime, primePower.power - 1);
	    	 if ( primePower.prime == 2 && primePower.power >= 3 ) {
	    		 car /= 2;
	    	 }	    	
	    	 result = lcm(result, car);
		}	
	    return result;
	}

	private static List<PrimePower> primePowers(int number) {
		List<PrimePower> powers = new ArrayList<PrimePower>();

	    for ( int i = 2; i <= Math.sqrt(number); i++ ) {
	        if ( number % i == 0 ) {
	        	powers.addLast( new PrimePower(i, 0) );
	            while ( number % i == 0 ) {
	            	PrimePower last = powers.removeLast();
	                powers.addLast( new PrimePower(last.prime, last.power + 1) );
	                number /= i;
	            }
	        }
	    }
	
	    if ( number > 1 ) {
	        powers.addLast( new PrimePower(number, 1) );
	    }	
	    return powers;
	}
	
	private static int lcm(int a, int b) {
		return a / gcd(a, b) * b;
	}
	
	private static int gcd(int a, int b) {
		return ( b == 0 ) ? a : gcd(b, a % b);
	}
	
	private static record PrimePower(int prime, int power) {}	

}
