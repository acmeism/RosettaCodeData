import java.util.List;

public final class ReducedRowEchelonForm {

	public static void main(String[] args) {
		double[][] first = new double[][] { {   1.0,   2.0,  -1.0,  -4.0 },
		                                    {   2.0,   3.0,  -1.0, -11.0 },
		                                    {  -2.0,   0.0,  -3.0,  22.0 } };
		
		double[][] second = new double[][] { { 1.0,  2.0,  3.0,  4.0,  3.0,  1.0 },
	           							     { 2.0,  4.0,  6.0,  2.0,  6.0,  2.0 },
	           						         { 3.0,  6.0, 18.0,  9.0,  9.0, -6.0 },
	           							     { 4.0,  8.0, 12.0, 10.0, 12.0,  4.0 },
	           							     { 5.0, 10.0, 24.0, 11.0, 15.0, -4.0 } };
	           							
	    List.of( first, second ).forEach( m -> {
	    	display("Original matrix:", m);
	    	display("Reduced row echelon form:", reducedRowEchelonForm(m));
	    } );
	}
	
	private static double[][] reducedRowEchelonForm(double[][] matrix) {	
	    final int rowCount = matrix.length;
	    final int colCount = matrix[0].length;
	
	    int lead = 0;	
	    for ( int row = 0; row < rowCount; row++ ) {
	        if ( colCount <= lead ) {
	            return matrix;
	        }
	
	        int ro = row;
	        while ( matrix[ro][lead] == 0.0 ) {
	            ro += 1;
	            if ( rowCount == ro ) {
	                ro = row;
	                lead += 1;
	                if ( colCount == lead ) {
	                    return matrix;
	                }
	            }
	        }
	
	        final double[] temp = matrix[row];
			matrix[row] = matrix[ro];
			matrix[ro] = temp;	
	
	        if ( matrix[row][lead] != 0.0 ) {
	        	final double divisor = matrix[row][lead];
	        	for ( int co = 0; co < matrix[0].length; co++ ) {
	    			matrix[row][co] /= divisor;
	    		}
	        }
	
	        for ( int j = 0; j < rowCount; j++ ) {
	            if ( j != row ) {
	            	final double multiple = matrix[j][lead];
	            	for ( int co = 0; co < matrix[0].length; co++ ) {
	        			matrix[j][co] -= matrix[row][co] * multiple;
	        		}
	        	}
	        }
	        lead += 1;
	    }
	    return matrix;
	}

	private static void display(String title, double[][] matrix) {
	    System.out.println(title);
	    final int rowCount = matrix.length;
	    final int colCount = matrix[0].length;

	    for ( int row = 0; row < rowCount; row++ ) {
	        for ( int col = 0; col < colCount; col++ ) {
	            if ( matrix[row][col] == -0.0 ) {
	            	matrix[row][col] = 0.0;
	            }
	            System.out.print(String.format("%6.1f", matrix[row][col]));
	        }
	        System.out.println();
	    }
	    System.out.println();
	}
	
}
