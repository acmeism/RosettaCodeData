import java.util.ArrayList;
import java.util.List;

public final class BernoullisTriangle {

	public static void main(String... args) {
		List<Integer> previousRow = new ArrayList<Integer>();
		
		for ( int n = 0; n < 15; n++ ) {
			List<Integer> currentRow = new ArrayList<Integer>();
		    for ( int k = 0; k <= n; k++ ) {
		        if ( k == 0 ) {
		            currentRow.addLast(1);
		        } else if ( k < n ) {
		            currentRow.addLast(previousRow.get(k) + previousRow.get(k - 1));
		        } else {
		            currentRow.add(2 * previousRow.getLast());
		        }
		    }
		
		    IO.println(currentRow);		
		    previousRow = currentRow;
		}
	}

}
