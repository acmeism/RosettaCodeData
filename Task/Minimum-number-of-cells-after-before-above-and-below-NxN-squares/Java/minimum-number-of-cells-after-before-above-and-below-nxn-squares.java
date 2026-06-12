import java.util.ArrayList;
import java.util.Comparator;
import java.util.List;

public final class MinimumNumberOfCellsAfterBeforeAboveBelowNxNSquares {

	public static void main(String[] args) {
		printMinimumCells(10);
	}
	
	private static void printMinimumCells(int n) {
	    System.out.println("Minimum number of cells after, before, above and below " + n + " x " + n + " square:");
	    for ( int row = 0; row < n; row++ ) {
	    	List<Integer> currentRow = new ArrayList<Integer>();
	    	for ( int col = 0; col < n; col++ ) {
	            currentRow.addLast(List.of( n - row - 1, row, col, n - col - 1 ).stream()
	            		               .min(Comparator.naturalOrder()).get());	
	    	}
	    	System.out.println(currentRow);
	    }	
	}

}
