import java.util.Arrays;
import java.util.HashMap;
import java.util.Map;
import java.util.concurrent.ThreadLocalRandom;

public final class LatinSquaresInReducedForm {

	public static void main(String[] args) {
	    System.out.println("PART 1: 10,000 latin Squares of order 4 in reduced form:" + "\n");
	    int[][] original4 = new int[][] { { 1, 2, 3, 4 }, { 2, 1, 4, 3 }, { 3, 4, 1, 2 }, { 4, 3, 2, 1 } };
	    Map<String, Integer> frequencies = new HashMap<String, Integer>();
	    int[][][] cube = createCube(original4, 4);	
	    for ( int i = 1; i <= 10_000; i++ ) {
	        shuffleCube(cube);
	        int[][] matrix = toMatrix(cube);
	        reduce(matrix);
	        oneBased(matrix);
	        frequencies.merge(Arrays.deepToString(matrix), 1, Integer::sum);
	    }
	
	    for ( Map.Entry<String, Integer> entry : frequencies.entrySet() ) {
	        System.out.print(entry.getKey());
	        System.out.println(" occurs " + entry.getValue() + " times");
	    }
	
	    System.out.println("\n" + "PART 2: 10_000 latin squares of order 5 in reduced form:");
	    int[][] original5 = new int[][] { { 1, 2, 3, 4, 5 }, { 2, 3, 4, 5, 1 },
	    	                              { 3, 4, 5, 1, 2 }, { 4, 5, 1, 2, 3 }, { 5, 1, 2, 3, 4 } };
	    frequencies.clear();
	    cube = createCube(original5, 5);	
	    for ( int i = 1; i <= 10_000; i++ ) {
	        shuffleCube(cube);
	        int[][] matrix = toMatrix(cube);
	        reduce(matrix);
	        frequencies.merge(Arrays.deepToString(matrix), 1, Integer::sum);
	    }
	
	    int count = 0;
	    for ( int frequency : frequencies.values() ) {
	        count += 1;
	        System.out.print(String.format("%s%s%2d%s%3d%s",
	        	( count > 1 ? ", " : "" ), ( count % 8 == 1 ? "\n" : "" ), count, "(", frequency, ")"));
	    }
	
	    System.out.println("\n\n" + "PART 3: 750 latin squares of order 42, showing the last one:" + "\n");
	    int[][] matrix42 = new int[42][];
	    cube = createCube(null, 42);
	    for ( int i = 1; i <= 750; i++ ) {
	        shuffleCube(cube);
	        if ( i == 750 ) {
	        	matrix42 = toMatrix(cube);
	        	oneBased(matrix42);
	        }
	    }
	    Arrays.stream(matrix42).forEach( row -> System.out.println(Arrays.toString(row)) );
	
	    System.out.println("\n" + "PART 4: 1,000 latin squares of order 256:" + "\n");
	    final long startTime = System.currentTimeMillis();
	    cube = createCube(null, 256);
	    for ( int i = 1; i <= 1_000; i++ ) {
	        shuffleCube(cube);
	    }
	    final long finishTime = System.currentTimeMillis();
	    System.out.println("Generated in " + ( finishTime - startTime ) + " milliseconds");
	}	
	
	private static void reduce(int[][] matrix) {
		for ( int j = 0; j < matrix.length - 1; j++ ) {
	        if ( matrix[0][j] != j ) {
	            for ( int k = j + 1; k < matrix.length; k++ ) {
	                if ( matrix[0][k] == j ) {
	                    for ( int i = 0; i < matrix.length; i++ ) {
	                    	final int temp = matrix[i][j];
	                    	matrix[i][j] = matrix[i][k];
	                    	matrix[i][k] = temp;
	                    }
	                    break;
	                }
	            }
	        }
	    }
		
		for ( int i = 1; i < matrix.length - 1; i++ ) {
	        if ( matrix[i][0] != i ) {
	            for ( int k = i + 1; k < matrix.length; k++ ) {
	                if ( matrix[k][0] == i ) {
	                    for ( int j = 0; j < matrix.length; j++ ) {
	                    	final int temp = matrix[i][j];
	                    	matrix[i][j] = matrix[k][j];
	                    	matrix[k][j] = temp;
	                    }
	                    break;
	                }
	            }
	        }
	    }		
	}	
	
	private static int[][] toMatrix(int[][][] cube) {
	    int[][] matrix = new int[cube.length][cube.length];
	    for ( int i = 0; i < cube.length; i++ ) {
	        for ( int j = 0; j < cube.length; j++ ) {
	            for ( int k = 0; k < cube.length; k++ ) {
	                if ( cube[i][j][k] != 0 ) {
	                    matrix[i][j] = k;
	                    break;
	                }
	            }
	        }
	    }	
	    return matrix;
	}	
	
	private static void shuffleCube(int[][][] cube) {
	    boolean proper = true;
	
	    int rx, ry, rz;
	    do {
	    	rx = random.nextInt(0, cube.length);
	    	ry = random.nextInt(0, cube.length);
	    	rz = random.nextInt(0, cube.length);	
	    } while ( cube[rx][ry][rz] != 0 );
	
	    while ( true ) {
	        int ox = 0, oy = 0, oz = 0;	

	        while ( cube[ox][ry][rz] != 1 ) {
	        	ox += 1;
	        }
	        while ( cube[rx][oy][rz] != 1 ) {
	        	oy += 1;
	        }
	        while ( cube[rx][ry][oz] != 1 ) {
	        	oz += 1;
	        }
	
	        if ( ! proper ) {		
		        if ( random.nextInt(2) == 0 ) {
		            ox += 1;
		            while ( cube[ox][ry][rz] != 1 ) {
			        	ox += 1;
			        }
		        }			
		        if ( random.nextInt(2) == 0 ) {
		            oy += 1;
		            while ( cube[rx][oy][rz] != 1 ) {
			        	oy += 1;
			        }
		        }		
		        if ( random.nextInt(2) == 0 ) {
		            oz += 1;
		            while ( cube[rx][ry][oz] != 1 ) {
			        	oz += 1;
			        }
		        }
	        }
	
	        cube[rx][ry][rz] += 1;
    	    cube[rx][oy][oz] += 1;
    	    cube[ox][ry][oz] += 1;
    	    cube[ox][oy][rz] += 1;

    	    cube[rx][ry][oz] -= 1;
    	    cube[rx][oy][rz] -= 1;
    	    cube[ox][ry][rz] -= 1;
    	    cube[ox][oy][oz] -= 1;
    	
    	    if ( cube[ox][oy][oz] < 0 ) {
    	    	rx = ox; ry = oy; rz = oz;
    	        proper = false;
    	    } else {
    	        break;
			}	
	    }
	}
		
	private static int[][][] createCube(int[][] matrix, int size) {
	    int[][][] cube = new int[size][size][size];
	    for ( int i = 0; i < size; i++ ) {
	        cube[i] = new int[size][size];
	        for ( int j = 0; j < size; j++ ) {
	            cube[i][j] = new int[size];
	            final int k = ( matrix == null ) ? ( i + j ) % size : matrix[i][j] - 1;
	            cube[i][j][k] = 1;
	        }
	    }
	    return cube;
	}
	
	private static void oneBased(int[][] matrix) {
		for ( int i = 0; i < matrix.length; i++ ) {
	        for ( int j = 0; j < matrix.length; j++ ) {
	            matrix[i][j] += 1;
	        }
	    }
	}
		
	private static ThreadLocalRandom random = ThreadLocalRandom.current();

}
