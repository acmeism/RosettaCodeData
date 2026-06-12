import java.util.ArrayList;
import java.util.List;

public class Sub_unitSquares {

	public static void main(String[] args) {
		final int sub_unitsRequired = 7;
		System.out.println("The first " + sub_unitsRequired + " sub-unit squares are:");
		System.out.println(1);
		long number = 2;
		int count = 1;
		while ( count < sub_unitsRequired ) {
		    final long square = number * number;
		    List<Integer> digits = digits(square);		
		    if ( ! digits.contains(0) && digits.get(0) != 1 ) {
		    	final long sub_unit = sub_unit(digits);
		        if ( isSquare(sub_unit) ) {
		            System.out.println(square);
		            count += 1;
		        }
		    }		
		    number += 1;
		}
		
	}
	
	private static boolean isSquare(long number) {
		final long squareRoot =(long) Math.sqrt(number);
		return number == squareRoot * squareRoot;
	}
	
	private static long sub_unit(List<Integer> digits) {
		long result = 0;
        for ( int digit : digits ) {
        	result = 10 * result + ( digit - 1 );
        }
        return result;
	}
	
	private static List<Integer> digits(long number) {
		List<Integer> result = new ArrayList<Integer>();
		while ( number != 0 ) {
			result.add(0, (int) ( number % 10 ) );
	        number /= 10;
	    }
		return result;
	}

}
