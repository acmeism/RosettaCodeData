import java.util.ArrayList;
import java.util.List;

public final class PenholodigitalSquares {

	public static void main(String[] args) {
		String digits = "0123456789abcdef";
		List<Integer> largestPrimeFactors = List.of( 1, 2, 3, 2, 5, 3, 7, 2, 3, 5, 11, 3, 13, 7, 5 );
		
		for ( int radix = 2; radix <= 16; radix++ ) {
		    List<String> penholo = new ArrayList<String>();
		    List<String> penholoSquares = new ArrayList<String>();
		
		    String radixDigits = digits.substring(1, radix);
			String reversed = new StringBuilder(radixDigits).reverse().toString();
			int min = (int) Math.ceil(Math.sqrt(Long.parseLong(radixDigits, radix)));
			final int max = (int) Math.floor(Math.sqrt(Long.parseLong(reversed, radix)));
    	    final int divisor = largestPrimeFactors.get(radix - 2);    	
    	    min += ( min % divisor == 0 ) ? 0 : ( divisor - min % divisor );

    	    for ( int number = min; number <= max; number += divisor ) {
    	    	String square = Long.toString((long) number * number, radix);
    	        if ( square.chars().filter( i -> i != 48 ).distinct().count() == radix - 1 ) {
    	        	penholo.addLast(Long.toString(number, radix));
    	        	penholoSquares.addLast(square);    	        	
    	        }
    	    }
    	
    	    System.out.println(
    	    	"There is a total of " + penholo.size() + " penholodigital squares in base " + radix + ":");
    	    if ( radix <= 13 ) {
    	    	for ( int i = 0; i < penholo.size(); i++ ) {
    	    		System.out.print(penholo.get(i) + "² = " + penholoSquares.get(i)
    	    			+ (  i % 3 == 2 ? "\n" : "    " ));
    	    	}    	    	
    	    	System.out.println( penholo.size() % 3 == 0 ? "" : System.lineSeparator());
    	    } else {
    	    	System.out.println(penholo.getFirst() + "² = " + penholoSquares.getFirst() + " ... "
    	    		+ penholo.getLast() + "² = " + penholoSquares.getLast() + System.lineSeparator());
    	    }
		}
	}	

}
