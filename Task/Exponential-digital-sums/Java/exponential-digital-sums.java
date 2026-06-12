import java.math.BigInteger;
import java.util.ArrayList;
import java.util.List;
import java.util.stream.Collectors;

public final class ExponentialDigitalSums {

	public static void main(String[] args) {
		System.out.println(
			"The first 25 integers that are equal to the digital sum of that integer raised to some power:");
		exponentialDigitalSums(25, 1, 100);
		System.out.println();
		System.out.println("The first 30 integers that satisfy the same condition in three or more ways:");
		exponentialDigitalSums(30, 3, 500);
	}
	
	private static void exponentialDigitalSums(int resultsCount, int minWays, int maxPower) {		
	    BigInteger number = BigInteger.ONE;
	    BigInteger copyNumber = BigInteger.ONE;
	    int count = 0;
	
	    while ( count < resultsCount ) {
	        number = number.add(BigInteger.ONE);
	        copyNumber = number;
	        List<String> result = new ArrayList<String>();
	        for ( int power = 2; power < maxPower; power++ ) {
	            copyNumber = copyNumber.multiply(number);
	            final int digitalSum = digitalSum(copyNumber);
	            if ( number.equals(BigInteger.valueOf(digitalSum)) ) {
	                result.add(number + "^" + power);
	            }
	        }
	
	        if ( result.size() >= minWays ) {
	            System.out.println(result.stream().collect(Collectors.joining(", ")));
	            count += 1;
	        }
	    }
	}
	
	private static int digitalSum(BigInteger number) {
		return number.toString().chars().mapToObj( i -> (int) ( i - '0' ) )
                     .collect(Collectors.summingInt(Integer::intValue));
	}

}
