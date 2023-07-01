import java.util.Arrays;
import java.util.Collections;
import java.util.Comparator;
import java.util.List;
import java.util.stream.IntStream;

public final class PancakeSort {

	public static void main(String[] aArgs) {
		List<Integer> numbers = Arrays.asList( 1, 5, 4, 2, 3, 2, 8, 6, 7 );
		System.out.println("Initial list: " + numbers);		
		pancakeSort(numbers);		
	}
	
	private static void pancakeSort(List<Integer> aList) {
		for ( int i = aList.size() - 1; i >= 0; i-- ) {	
	    	int index = IntStream.rangeClosed(0, i).boxed().max(Comparator.comparing(aList::get)).get();
		
		    if ( index != i ) {
		    	flip(aList, index);
		    	flip(aList, i);
		    }		
		}
	}
	
	private static void flip(List<Integer> aList, int aIndex) {
		if ( aIndex > 0 ) {
			Collections.reverse(aList.subList(0, aIndex + 1));		
			System.out.println("flip 0.." + aIndex + " --> " + aList);
		}
	}

}
