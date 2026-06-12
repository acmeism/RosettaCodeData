import java.util.ArrayList;
import java.util.List;
import java.util.function.IntPredicate;

public class SelfContainedNumbers {

	public static void main(String[] args) {
		IntPredicate isSelfContained = n -> {
			int collatz = n;
		    while ( collatz > 1 ) {
		        collatz = ( collatz % 2 == 0 ) ? collatz >> 1 : collatz * 3 + 1;
		        if ( collatz % n == 0 ) {
		            return true;
		        }
		    }
		    return false;
		};
		
		List<Integer> result = new ArrayList<Integer>();
		int number = 3;
		while ( result.size() < 7 ) {
			if ( isSelfContained.test(number) ) {
				result.addLast(number);
			}
			number += 2;
		}
		
		System.out.println("The first seven self-contained numbers are: " + result);
	}

}
