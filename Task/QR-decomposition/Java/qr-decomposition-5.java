import java.util.ArrayList;
import java.util.List;

public final class QRDecomposition {

	public static void main(String[] aArgs) {
		final double[][] data = new double [][] { { 12.0, -51.0,   4.0 },
				  						          {  6.0, 167.0, -68.0 },
				  						          { -4.0,  24.0, -41.0 },
				  						          { -1.0,   1.0,   0.0 },
				  						          {  2.0,   0.0,   3.0 } };
		
		// Task 1		  						
		Matrix A = new Matrix(data);				  						
		A.display("Initial matrix A:");
		
		MatrixPair pair = householder(A);		
		Matrix Q = pair.q;
		Matrix R = pair.r;
		
		Q.display("Matrix Q:");
		R.display("Matrix R:");
		
		Matrix result = Q.multiply(R);
		result.display("Matrix Q * R:");
		
		// Task 2
		Matrix x = new Matrix(
            new double[][] { { 0.0, 1.0, 2.0, 3.0, 4.0, 5.0, 6.0, 7.0, 8.0, 9.0, 10.0 } } );
		Matrix y = new Matrix(
			new double[][] { { 1.0, 6.0, 17.0, 34.0, 57.0, 86.0, 121.0, 162.0, 209.0, 262.0, 321.0 } } );
		
		result = fitPolynomial(x, y, 2);
		result.display("Result of fitting polynomial:");
	}
	
	private static MatrixPair householder(Matrix aMatrix) {
		final int rowCount = aMatrix.getRowCount();
		final int columnCount = aMatrix.getColumnCount();
		List<Matrix> versionsOfQ = new ArrayList<Matrix>(rowCount);
		Matrix z = new Matrix(aMatrix);
		Matrix z1 = new Matrix(rowCount, columnCount);
		
		for ( int k = 0; k < columnCount && k < rowCount - 1; k++ ) {
			Matrix vectorE = new Matrix(rowCount, 1);		
		    z1 = z.minor(k);
		    Matrix vectorX = z1.column(k);	    	
		    double magnitudeX = vectorX.magnitude();
		    if ( aMatrix.getEntry(k, k) > 0 ) {
		    	magnitudeX = -magnitudeX;
		    }

		    for ( int i = 0; i < vectorE.size(); i++ ) {
		        vectorE.setEntry(i, 0, ( i == k ) ? 1 : 0);
		    }			
		    vectorE = vectorE.scalarMultiply(magnitudeX).add(vectorX).unit();	
		    versionsOfQ.add(householderFactor(vectorE));
		    z = versionsOfQ.get(k).multiply(z1);
		}
		
		Matrix Q = versionsOfQ.get(0);
	    for ( int i = 1; i < columnCount && i < rowCount - 1; i++ ) {
	    	Q = versionsOfQ.get(i).multiply(Q);
	    }

	    Matrix R = Q.multiply(aMatrix);
	    Q = Q.transpose();
	    return new MatrixPair(R, Q);
	}
	
	public static Matrix householderFactor(Matrix aVector) {
    	if ( aVector.getColumnCount() != 1 ) {
        	throw new RuntimeException("Incompatible matrix dimensions.");
        }
    	
    	final int size = aVector.size();
    	Matrix result = new Matrix(size, size);
	    for ( int i = 0; i < size; i++ ) {
	        for ( int j = 0; j < size; j++ ) {
	        	result.setEntry(i, j, -2 * aVector.getEntry(i, 0) * aVector.getEntry(j, 0));
	        }
	    }
	
	    for ( int i = 0; i < size; i++ ) {
	    	result.setEntry(i, i, result.getEntry(i, i) + 1.0);
	    }
	    return result;
    }
	
	private static Matrix fitPolynomial(Matrix aX, Matrix aY, int aPolynomialDegree) {
	    Matrix vandermonde = new Matrix(aX.getColumnCount(), aPolynomialDegree + 1);
	    for ( int i = 0; i < aX.getColumnCount(); i++ ) {
	        for ( int j = 0; j < aPolynomialDegree + 1; j++ ) {
	            vandermonde.setEntry(i, j, Math.pow(aX.getEntry(0, i), j));
	        }
		}
	    return leastSquares(vandermonde, aY.transpose());
	}
	
	private static Matrix leastSquares(Matrix aVandermonde, Matrix aB) {
		MatrixPair pair = householder(aVandermonde);
		return solveUpperTriangular(pair.r, pair.q.transpose().multiply(aB));
	}
	
	private static Matrix solveUpperTriangular(Matrix aR, Matrix aB) {
		final int columnCount = aR.getColumnCount();
	    Matrix result = new Matrix(columnCount, 1);

	    for ( int k = columnCount - 1; k >= 0; k-- ) {
	        double total = 0.0;
	        for ( int j = k + 1; j < columnCount; j++ ) {
	            total += aR.getEntry(k, j) * result.getEntry(j, 0);
	        }
	        result.setEntry(k, 0, ( aB.getEntry(k, 0) - total ) / aR.getEntry(k, k));
	    }
	    return result;
	}
	
	private static record MatrixPair(Matrix r, Matrix q) {}

}

final class Matrix {

    public Matrix(double[][] aData) {
        rowCount = aData.length;
        columnCount = aData[0].length;
        data = new double[rowCount][columnCount];
        for ( int i = 0; i < rowCount; i++ ) {
            for ( int j = 0; j < columnCount; j++ ) {
                data[i][j] = aData[i][j];
            }
        }
    }

    public Matrix(Matrix aMatrix) {
    	this(aMatrix.data);
    }

    public Matrix(int aRowCount, int aColumnCount) {
        this( new double[aRowCount][aColumnCount] );
    }

    public Matrix add(Matrix aOther) {
        if ( aOther.rowCount != rowCount || aOther.columnCount != columnCount ) {
        	throw new IllegalArgumentException("Incompatible matrix dimensions.");
        }

        Matrix result = new Matrix(data);
        for ( int i = 0; i < rowCount; i++ ) {
            for ( int j = 0; j < columnCount; j++ ) {
                result.data[i][j] = data[i][j] + aOther.data[i][j];
            }
        }
        return result;
    }

    public Matrix multiply(Matrix aOther) {
        if ( columnCount != aOther.rowCount ) {
        	throw new IllegalArgumentException("Incompatible matrix dimensions.");
        }

        Matrix result = new Matrix(rowCount, aOther.columnCount);
        for ( int i = 0; i < rowCount; i++ ) {
            for ( int j = 0; j < aOther.columnCount; j++ ) {
                for ( int k = 0; k < rowCount; k++ ) {
                    result.data[i][j] += data[i][k] * aOther.data[k][j];
                }
            }
        }
        return result;
    }

    public Matrix transpose() {
        Matrix result = new Matrix(columnCount, rowCount);
        for ( int i = 0; i < rowCount; i++ ) {
            for ( int j = 0; j < columnCount; j++ ) {
                result.data[j][i] = data[i][j];
            }
        }
        return result;
    }

    public Matrix minor(int aIndex) {
    	Matrix result = new Matrix(rowCount, columnCount);
        for ( int i = 0; i < aIndex; i++ ) {
            result.setEntry(i, i, 1.0);
        }

        for ( int i = aIndex; i < rowCount; i++ ) {
            for ( int j = aIndex; j < columnCount; j++ ) {
        	    result.setEntry(i, j, data[i][j]);
            }
        }
        return result;
    }	
	
	public Matrix column(int aIndex) {
		Matrix result = new Matrix(rowCount, 1);
		for ( int i = 0; i < rowCount; i++ ) {
		    result.setEntry(i, 0, data[i][aIndex]);
		}
		return result;		
	}
	
	public Matrix scalarMultiply(double aValue) {
		if ( columnCount != 1 ) { 			
			throw new IllegalArgumentException("Incompatible matrix dimension.");
		}
		
		Matrix result = new Matrix(rowCount, columnCount);
		for ( int i = 0; i < rowCount; i++ ) {
		    result.data[i][0] = data[i][0] * aValue;
	    }
		return result;
	}
	
	public Matrix unit() {
		if ( columnCount != 1 ) { 			
			throw new IllegalArgumentException("Incompatible matrix dimensions.");
		}
		
		final double magnitude = magnitude();
		Matrix result = new Matrix(rowCount, columnCount);
		for ( int i = 0; i < rowCount; i++ ) {
		    result.data[i][0] = data[i][0] / magnitude;
	    }
		return result;
	}
	
	public double magnitude() {
		if ( columnCount != 1 ) { 			
			throw new IllegalArgumentException("Incompatible matrix dimensions.");
		}
		
		double norm = 0.0;
	    for ( int i = 0; i < data.length; i++ ) {
		    norm += data[i][0] * data[i][0];
	    }
	    return Math.sqrt(norm);		
	}
	
	public int size() {
		if ( columnCount != 1 ) { 			
			throw new IllegalArgumentException("Incompatible matrix dimensions.");
		}
		return rowCount;
	}
	
	public void display(String aTitle) {
		System.out.println(aTitle);
		for ( int i = 0; i < rowCount; i++ ) {
		    for ( int j = 0; j < columnCount; j++ ) {
		    	System.out.print(String.format("%9.4f", data[i][j]));
		    }
		    System.out.println();
		}
		System.out.println();
	}
	
    public double getEntry(int aRow, int aColumn) {
    	return data[aRow][aColumn];
    }

    public void setEntry(int aRow, int aColumn, double aValue) {
    	data[aRow][aColumn] = aValue;
    }

    public int getRowCount() {
    	return rowCount;
    }

    public int getColumnCount() {
    	return columnCount;
    }

    private final int rowCount;
    private final int columnCount;
    private final double[][] data;

}
