import java.util.ArrayList;
import java.util.Collections;
import java.util.List;
import java.util.stream.IntStream;

public final class CountTheOccurrencesOfEachDigitInE {

	public static void main(String[] args) {
		// Counting the occurrences of the first 4,000 digits of Euler's number e.
		// That is, the initial digit '2' before the decimal point and the first 3,999 digits after the decimal point.
		final int maxIndex = 2_000;
		List<Integer> values = new ArrayList<Integer>(Collections.nCopies(maxIndex, 1));
		List<Integer> digitCounts = new ArrayList<Integer>(List.of( 0, 0, 1, 0, 0, 0, 0, 0, 0, 0 ));
		
		IntStream.range(0, 2 * maxIndex - 1).forEach( _ -> {
		    int a = maxIndex + 1;
		    int c = 0;
		
		    for ( int i = 0; i < maxIndex; i++ ) {
		        c += values.get(i) * 10;
		        values.set(i, c % a);
		        c /= a;
		        a -= 1;
			}
		    digitCounts.set(c, digitCounts.get(c) + 1);
		} );
		
		System.out.println("The counts for the digits 0, 1, 2, ... , 9 are:");
		System.out.println(digitCounts + System.lineSeparator());
		System.out.print("The number of digits counted is " + digitCounts.stream().mapToInt(Integer::intValue).sum());
	}

}
