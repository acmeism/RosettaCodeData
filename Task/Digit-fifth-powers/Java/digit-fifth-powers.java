import java.util.List;
import java.util.stream.IntStream;

public final class DigitFifthPowers {

	public static void main(String[] args) {
		List<Integer> digitFifthPowers = IntStream.rangeClosed(0, 9).map( i -> (int) Math.pow(i, 5) ).boxed().toList();
		
		System.out.println("The sum of all numbers that are the sum of the 5th powers of their digits is:");
		final int limit = digitFifthPowers.get(9) * 6;
		int sum = 0;
		for ( int i = 2; i <= limit; i++ ) {
			List<Integer> digits = String.valueOf(i).chars().map(Character::getNumericValue).boxed().toList();
		    final int totalPowers = digits.stream().reduce(0, (total, index) -> total + digitFifthPowers.get(index) );
		    if ( totalPowers == i ) {
		        System.out.print(( sum == 0 ) ? i : " + " + i );
		        sum += i;
		    }
		}
		System.out.println(" = " + sum);
	}
	
}
