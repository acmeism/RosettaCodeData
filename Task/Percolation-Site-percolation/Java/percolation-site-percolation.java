import java.util.concurrent.ThreadLocalRandom;

public final class PercolationSite {

	public static void main(String[] aArgs) {		
		final int rowCount = 15;
		final int colCount = 15;
		final int testCount = 1_000;
		
		Grid grid = new Grid(rowCount, colCount, 0.5);
		grid.percolate();
		grid.display();
		
		System.out.println("Proportion of " + testCount + " tests that percolate through the grid:");
	    for ( double probable = 0.0; probable <= 1.0; probable += 0.1 ) {
	    	int percolationCount = 0;
	        for ( int test = 0; test < testCount; test++) {
	            Grid testGrid = new Grid(rowCount, colCount, probable);
	            if ( testGrid.percolate() ) {
	            	percolationCount += 1;
	            }
	        }
	        double percolationProportion = (double) percolationCount / testCount;
	        System.out.println(String.format("%s%.1f%s%.4f", " p = ", probable, ": ", percolationProportion));
	    }
	}

}

final class Grid {
	
	public Grid(int aRowCount, int aColCount, double aProbability) {
		createGrid(aRowCount, aColCount, aProbability);
	}
	
	public boolean percolate() {
		for ( int x = 0; x < table[0].length; x++ ) {
			if ( pathExists(x, 0) ) {
				return true;
			}
		}
		return false;
	}
	
	public void display() {
	    for ( int col = 0; col < table.length; col++ ) {
	        for ( int row = 0; row < table[0].length; row++ ) {
	            System.out.print(" " + table[col][row]);
	        }
	        System.out.println();
	    }
	    System.out.println();
	}
	
	private boolean pathExists(int aX, int aY) {		
	    if ( aY < 0 || aX < 0 || aX >= table[0].length || table[aY][aX].compareTo(FILLED) != 0 ) {
	    	return false;
	    }
	    table[aY][aX] = PATH;
	    if ( aY == table.length - 1 ) {
	    	return true;
	    }
	    return pathExists(aX, aY + 1) || pathExists(aX + 1, aY) || pathExists(aX - 1, aY) || pathExists(aX, aY - 1);
	}
	
	private void createGrid(int aRowCount, int aColCount, double aProbability) {
		table = new String[aRowCount][aColCount];		
		for ( int col = 0; col < aRowCount; col++ ) {
			for ( int row = 0; row < aColCount; row++ ) {
				table[col][row] = ( RANDOM.nextFloat(1.0F) < aProbability ) ? FILLED: EMPTY;
			}
		}	
	}
	
	private String[][] table;
	
	private static final String EMPTY = " ";
	private static final String FILLED = ".";
	private static final String PATH = "#";
	private static final ThreadLocalRandom RANDOM = ThreadLocalRandom.current();
	
}
