import java.util.Arrays;
import java.util.List;
import java.util.function.Function;

public final class MultidimensionalNewtonRaphsonMethod {

	public static void main(String[] args) {
		/**
		 * Solve the two non-linear equations:
		 *    y + x^2 - x - 0.5 = 0
		 *    y + 5xy - x^2 = 0
		 *    with initial values of x = 1.2, y = 1.2
		 */
		List<Function<Double[], Double>> functions = List.of(
			a -> a[1] + a[0] * a[0] - a[0] - 0.5,
			a -> a[1] + 5.0 * a[0] * a[1] - a[0] * a[0]
		);		
		
		List<List<Function<Double[], Double>>> jacobian = List.of(
			List.of( a -> 2.0 * a[0] - 1.0,        a -> 1.0 ),
			List.of( a -> 5.0 * a[1] - 2.0 * a[0], a -> 1.0 + 5.0 * a[0] )
		);

		Double[] initialValues = new Double[] { 1.2, 1.2 };		
		
		Double[] result = solve(functions, jacobian, initialValues);
		System.out.println(Arrays.toString(result));
		
		/**
		 * Solve the three non-linear equations:
		 *  9x^2 + 36y^2 + 4z^2 - 36 = 0
		 *  x^2 - 2y^2 - 20z = 0
		 *  x^2 - y^2 + z^2 = 0
		 *  with initial values of x = 1.0, y = 1.0 and z = 0.0
		 */
		functions = List.of(
			a -> 9.0 * a[0] * a[0] + 36.0 * a[1] * a[1] + 4 * a[2] * a[2] - 36.0,
			a -> a[0] * a[0] - 2.0 * a[1] * a[1] - 20.0 * a[2],
			a -> a[0] * a[0] - a[1] * a[1] + a[2] * a[2]
		);	
		
		jacobian = List.of(
			List.of( a -> 18.0 * a[0], a -> 72.0 * a[1], a -> 8.0 * a[2] ),
			List.of( a -> 2.0 * a[0], a -> -4.0 * a[1], a -> -20.0 ),
			List.of( a -> 2.0 * a[0], a -> -2.0 * a[1], a -> 2.0 * a[2] )
		);
		
		initialValues = new Double[] { 1.0, 1.0, 0.0 };	
		
		result = solve(functions, jacobian, initialValues);
		System.out.println(Arrays.toString(result));
	}
	
	private static Double[] solve(List<Function<Double[], Double>> functions,
								  List<List<Function<Double[], Double>>> jacobian,
								  Double[] values) {
	    final int size = functions.size();
	    final double epsilon = 0.000_000_08;
	    final int maxIterations = 4;
	    int iteration = 0;
	    double maxChange = 0.0;	
	
	    while ( iteration < maxIterations || maxChange < epsilon ) {
	    	double[][] column = new double[size][1];
	    	for ( int i = 0; i < size; i++ ) {
                column[i][0] = functions.get(i).apply(values);
	    	}
	    	
	    	double[][] jac = new double[size][values.length];
	    	for ( int i = 0; i < size; i++ ) {
	    		for ( int j = 0; j < size; j++ ) {
	    			jac[i][j] = jacobian.get(i).get(j).apply(values);
	    		}
	    	}
	    	
	    	double[][] jacInverse = inverse(jac);
	    	double[][] delta = multiply(jacInverse, column);
	    	
	    	for ( int i = 0; i < size; i++ ) {
	            values[i] -= delta[i][0];
	            if ( Math.abs(delta[i][0]) > maxChange ) {
	                maxChange = Math.abs(delta[i][0]);
	            }
	    	}
	    	
	    	iteration += 1;
	    }
	    return values;
	}
	
	private static double[][] multiply(double[][] one, double[][] two) {
		if ( one[0].length != two.length ) {
			throw new AssertionError("Incompatible array sizes");
		}		
		
		final int rowCount = one.length;
		final int colCount = two[0].length;
		double[][] result = new double[rowCount][colCount];
		for ( int row = 0; row < rowCount; row++ ) {
	    	for ( int col = 0; col < colCount; col++ ) {
	    		for ( int k = 0; k < rowCount; k++ ) {
	    			result[row][col] += one[row][k] * two[k][col];
	    		}
	    	}
		}
		return result;	        		
	}
	
	private static double[][] inverse(double[][] array) {
		if ( array.length != array[0].length ) {
			throw new AssertionError("Not a square array");
		}
		
		final int size = array.length;
		double[][] augmented = new double[size][2 * size];
		for ( int row = 0; row < size; row++ ) {
	    	for ( int col = 0; col < size; col++ ) {
	    		augmented[row][col] = array[row][col];
	    	}
			// Copy identity matrix to the right hand side of augmented matrix
			augmented[row][row + size] = 1.0;
		}

		augmented = toReducedRowEchelonForm(augmented);
		double[][] result = new double[size][size];
		// Copy inverse matrix from right hand side of augmented matrix
		for ( int row = 0; row < size; row++ ) {
	    	for ( int col = 0; col < size; col++ ) {
	    		result[row][col] = augmented[row][col + size];
	    	}
		}
		return result;
	}
	
	private static double[][] toReducedRowEchelonForm(double[][] array) {
		final int rowCount = array.length;
		final int colCount = array[0].length;
		
	    int lead = 0;
	    for ( int row = 0; row < rowCount; row++ ) {
	    	if ( colCount <= lead ) { return array; }
	    	int i = row;

	        while ( array[i][lead] == 0 ) {
	        	i += 1;
	        	if ( rowCount == i ) {
	        		i = row;
	        		lead += 1;
	        		if ( colCount == lead ) { return array; }
	        	}
	        }

	        final double[] temp = array[i]; array[i] = array[row]; array[row] = temp;

	        if ( array[row][lead] != 0 ) {
	        	final double divisor = array[row][lead];
	        	for ( int col = 0; col < colCount; col++ ) {
	        		array[row][col] /= divisor;
	        	}
	        }

	        for ( int k = 0; k < rowCount; k++ ) {
	        	if ( k != row ) {
	        		final double multiplier = array[k][lead];
	        		for ( int j = 0; j < colCount; j++ ) {
	        			array[k][j] -= array[row][j] * multiplier;
	        		}
	        	}
	        }

	        lead += 1;
	    }
	    return array;
	}

}
