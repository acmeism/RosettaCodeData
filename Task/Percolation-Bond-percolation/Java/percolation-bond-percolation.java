import java.util.Arrays;
import java.util.concurrent.ThreadLocalRandom;

public final class PercolationBond {

	public static void main(String[] aArgs) {
		System.out.println("Sample percolation with a " + COL_COUNT + " x " + ROW_COUNT + " grid:");
		makeGrid(0.5);
		percolate();
		showGrid();
		
		System.out.println("Using 10,000 repetitions for each probability p:");
	    for ( int p = 1; p <= 9; p++ ) {
	        int percolationCount = 0;
	        double probability = p / 10.0;
	        for ( int i = 0; i < 10_000; i++ ) {
	            makeGrid(probability);
	            if ( percolate() ) {
	            	percolationCount += 1;
	            }
	        }
	        final double percolationProportion = (double) percolationCount / 10_000;
	        System.out.println(String.format("%s%.1f%s%.4f", "p = ", probability, ":  ", percolationProportion));
	    }
	}
	
	private static void makeGrid(double aProbability) {	
	    Arrays.fill(grid, 0);
	    for ( int i = 0; i < COL_COUNT; i++ ) {
	    	grid[i] = LOWER_WALL | RIGHT_WALL;
	    }

	    endOfRow = COL_COUNT;
	    for ( int i = 0; i < ROW_COUNT; i++ ) {
	        for ( int j = COL_COUNT - 1; j >= 1; j-- ) {	        	
	        	final boolean chance1 = RANDOM.nextDouble() < aProbability;
	        	final boolean chance2 = RANDOM.nextDouble() < aProbability;
	            grid[endOfRow++] = ( chance1 ? LOWER_WALL : 0 ) | ( chance2 ? RIGHT_WALL : 0 );
	        }
	        final boolean chance3 = RANDOM.nextDouble() < aProbability;
	        grid[endOfRow++] = RIGHT_WALL | ( chance3 ? LOWER_WALL : 0 );
	    }
	}
	
	private static void showGrid() {
		for ( int j = 0; j < COL_COUNT; j++ ) {
	    	System.out.print("+--");
	    }
	    System.out.println("+");
		
		for ( int i = 0; i < ROW_COUNT; i++ ) {
			System.out.print("|");
	        for ( int j = 0; j < COL_COUNT; j++ ) {
	            System.out.print( ( ( grid[i * COL_COUNT + j + COL_COUNT] & FILL ) != 0 ) ? "[]" : "  " );
	            System.out.print( ( ( grid[i * COL_COUNT + j + COL_COUNT] & RIGHT_WALL ) != 0 ) ? "|" : " " );
	        }
	        System.out.println();
		
	        for ( int j = 0; j < COL_COUNT; j++ ) {
	            System.out.print( ( ( grid[i * COL_COUNT + j + COL_COUNT] & LOWER_WALL) != 0 ) ? "+--" : "+  " );
	        }
	        System.out.println("+");
		}
		
		System.out.print(" ");
		for ( int j = 0; j < COL_COUNT; j++ ) {
            System.out.print( ( ( grid[ROW_COUNT * COL_COUNT + j + COL_COUNT] & FILL ) != 0 ) ? "[]" : "  " );
            System.out.print( ( ( grid[ROW_COUNT * COL_COUNT + j + COL_COUNT] & RIGHT_WALL ) != 0 ) ? "|" : " " );
        }
        System.out.println(System.lineSeparator());
	}
	
	private static boolean fill(int aGridIndex) {
	    if ( ( grid[aGridIndex] & FILL ) != 0 ) {
	    	return false;
	    }	
	    grid[aGridIndex] |= FILL;
	
	    if ( aGridIndex >= endOfRow ) {
	    	return true;
	    }	
	    return ( ( ( grid[aGridIndex]             & LOWER_WALL ) == 0 ) && fill(aGridIndex + COL_COUNT) ) ||
	           ( ( ( grid[aGridIndex]             & RIGHT_WALL ) == 0 ) && fill(aGridIndex + 1) )         ||
	           ( ( ( grid[aGridIndex - 1]         & RIGHT_WALL ) == 0 ) && fill(aGridIndex - 1) )         ||
	           ( ( ( grid[aGridIndex - COL_COUNT] & LOWER_WALL ) == 0 ) && fill(aGridIndex - COL_COUNT) );
	}

	private static boolean percolate() {
		int i = 0;
	    while ( i < COL_COUNT && ! fill(COL_COUNT + i) ) {
	    	i++;
	    }
	    return i < COL_COUNT;
	}
		
	private static final int ROW_COUNT = 10;
	private static final int COL_COUNT = 10;
	
	private static int endOfRow = COL_COUNT;
	private static int[] grid = new int[COL_COUNT * ( ROW_COUNT + 2 )];

	private static final int FILL = 1;
	private static final int RIGHT_WALL = 2;
	private static final int LOWER_WALL = 4;

	private static final ThreadLocalRandom RANDOM = ThreadLocalRandom.current();
	
}
