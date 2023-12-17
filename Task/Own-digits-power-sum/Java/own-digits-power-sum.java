import java.util.List;
import java.util.stream.Collectors;
import java.util.stream.IntStream;

public final class OwnDigitsPowerSum {

	public static void main(String[] args) {
		List<Integer> powers = IntStream.rangeClosed(0, 9).boxed().map( i -> i * i ).collect(Collectors.toList());
		
		System.out.println("Own digits power sums for N = 3 to 9 inclusive:");

	    for ( int n = 3; n <= 9; n++ ) {
	        for ( int d = 2; d <= 9; d++ ) {
	            powers.set(d, powers.get(d) * d);
	        }
	
	        long number = (long) Math.pow(10, n - 1);
	        long maximum = number * 10;
	        int lastDigit = 0;
	        int sum = 0;
	
	        while ( number < maximum ) {
	            if ( lastDigit == 0 ) {
	            	sum = String.valueOf(number)
	            		.chars().map(Character::getNumericValue).map( i -> powers.get(i) ).sum();
	            } else if ( lastDigit == 1 ) {
	                sum += 1;
	            } else {
	                sum += powers.get(lastDigit) - powers.get(lastDigit - 1);
	            }
	
	            if ( sum == number ) {
	                System.out.println(number);
	                if ( lastDigit == 0 ) {
	                    System.out.println(number + 1);
	                }
	                number += 10 - lastDigit;
	                lastDigit = 0;
	            } else if ( sum > number ) {
	                number += 10 - lastDigit;
	                lastDigit = 0;
	            } else if ( lastDigit < 9 ) {
	                number += 1;
	                lastDigit += 1;
	            } else {
	                number += 1;
	                lastDigit = 0;
	            }	
	        }	
	    }
	}

}
