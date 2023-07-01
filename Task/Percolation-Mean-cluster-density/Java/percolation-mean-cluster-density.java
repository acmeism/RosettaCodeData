import java.util.List;
import java.util.concurrent.ThreadLocalRandom;

public final class PercolationMeanCluster {

	public static void main(String[] aArgs) {
		final int size = 15;
		final double probability = 0.5;
		final int testCount = 5;
		
		Grid grid = new Grid(size, probability);
		System.out.println("This " + size + " by " + size + " grid contains " + grid.clusterCount() + " clusters:");
		grid.display();		
			
		System.out.println(System.lineSeparator() + " p = 0.5, iterations = " + testCount);
		List<Integer> gridSizes = List.of( 10, 100, 1_000, 10_000 );	
		for ( int gridSize : gridSizes ) {			
			double sumDensity = 0.0;
			for ( int test = 0; test < testCount; test++ ) {
				grid = new Grid(gridSize, probability);
				sumDensity += grid.clusterDensity();
			}
			double result = sumDensity / testCount;
			System.out.println(String.format("%s%5d%s%.6f", " n = ", gridSize, ", simulation K = ", result));
		}
	}
	
}
	
final class Grid {
	
	public Grid(int aSize, double aProbability) {
		createGrid(aSize, aProbability);
		countClusters();
	}
	
	public int clusterCount() {
		return clusterCount;
	}
	
	public double clusterDensity() {
		return (double) clusterCount / ( grid.length * grid.length );
	}
	
	public void display() {
	    for ( int row = 0; row < grid.length; row++ ) {
	        for ( int col = 0; col < grid.length; col++ ) {
	        	int value = grid[row][col];
	        	char ch = ( value < GRID_CHARACTERS.length() ) ? GRID_CHARACTERS.charAt(value) : '?';
	            System.out.print(" " + ch);
	        }
	        System.out.println();
	    }
	}

    private void countClusters() {
	    clusterCount = 0;
	    for ( int row = 0; row < grid.length; row++ ) {
	        for ( int col = 0; col < grid.length; col++ ) {
	            if ( grid[row][col] == CLUSTERED ) {
	                clusterCount += 1;
	                identifyCluster(row, col, clusterCount);
	            }
	        }
	    }
	}
	
	private void identifyCluster(int aRow, int aCol, int aCount) {
		grid[aRow][aCol] = aCount;
		if ( aRow < grid.length - 1 && grid[aRow + 1][aCol] == CLUSTERED ) {
			identifyCluster(aRow + 1, aCol, aCount);
		}
		if ( aCol < grid[0].length - 1 && grid[aRow][aCol + 1] == CLUSTERED ) {
		    identifyCluster(aRow, aCol + 1, aCount);
		}
		if ( aCol > 0 && grid[aRow][aCol - 1] == CLUSTERED ) {
		   	identifyCluster(aRow, aCol - 1, aCount);
		}
		if ( aRow > 0 && grid[aRow - 1][aCol] == CLUSTERED ) {
		    identifyCluster(aRow - 1, aCol, aCount);
		}
	}		
	
	private void createGrid(int aGridSize, double aProbability) {
        grid = new int[aGridSize][aGridSize];		
		for ( int row = 0; row < aGridSize; row++ ) {
			for ( int col = 0; col < aGridSize; col++ ) {
				if ( random.nextDouble(1.0) < aProbability ) {
					grid[row][col] = CLUSTERED;
				}
			}
		}		
	}
	
	private int[][] grid;
	private int clusterCount;

    private static ThreadLocalRandom random = ThreadLocalRandom.current();

	private static final int CLUSTERED = -1;
	private static final String GRID_CHARACTERS = ".ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz";
	
}
