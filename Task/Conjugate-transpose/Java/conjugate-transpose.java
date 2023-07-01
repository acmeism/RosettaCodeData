import java.util.Arrays;
import java.util.List;

public final class ConjugateTranspose {

	public static void main(String[] aArgs) {		
		ComplexMatrix one = new ComplexMatrix( new Complex[][] { { new Complex(0, 4), new Complex(-1, 1) },
											                     { new Complex(1, -1), new Complex(0, 4) } } );		

		ComplexMatrix two = new ComplexMatrix(
			new Complex[][] { { new Complex(1, 0), new Complex(1, 1), new Complex(0, 2) },
			     			  { new Complex(1, -1), new Complex(5, 0), new Complex(-3, 0) },
							  { new Complex(0, -2), new Complex(-3, 0), new Complex(0, 0) } } );

		final double term = 1.0 / Math.sqrt(2.0);
		ComplexMatrix three = new ComplexMatrix( new Complex[][] { { new Complex(term, 0), new Complex(term, 0) },
																   { new Complex(0, term), new Complex(0, -term) } } );
		
		List<ComplexMatrix> matricies = List.of( one, two, three );
		for ( ComplexMatrix matrix : matricies ) {
			System.out.println("Matrix:");
			matrix.display();
			System.out.println("Conjugate transpose:");
			matrix.conjugateTranspose().display();
			System.out.println("Hermitian: " + matrix.isHermitian());
			System.out.println("Normal: " + matrix.isNormal());
			System.out.println("Unitary: " + matrix.isUnitary() + System.lineSeparator());
		}
	}

}

final class ComplexMatrix {
	
	public ComplexMatrix(Complex[][] aData) {
		rowCount = aData.length;
        colCount = aData[0].length;
        data = Arrays.stream(aData).map( row -> Arrays.copyOf(row, row.length) ).toArray(Complex[][]::new);
	}
	
	public ComplexMatrix multiply(ComplexMatrix aOther) {
        if ( colCount != aOther.rowCount ) {
        	throw new RuntimeException("Incompatible matrix dimensions.");
        }
        Complex[][] newData = new Complex[rowCount][aOther.colCount];
        Arrays.stream(newData).forEach( row -> Arrays.fill(row, new Complex(0, 0)) );
        for ( int row = 0; row < rowCount; row++ ) {
            for ( int col = 0; col < aOther.colCount; col++ ) {
                for ( int k = 0; k < colCount; k++ ) {
                    newData[row][col] = newData[row][col].add(data[row][k].multiply(aOther.data[k][col]));
                }
            }
        }
        return new ComplexMatrix(newData);
    }

    public ComplexMatrix conjugateTranspose() {
    	if ( rowCount != colCount ) {
    		throw new IllegalArgumentException("Only applicable to a square matrix");
    	}    	
    	Complex[][] newData = new Complex[colCount][rowCount];
        for ( int row = 0; row < rowCount; row++ ) {
            for ( int col = 0; col < colCount; col++ ) {
                newData[col][row] = data[row][col].conjugate();
            }
        }
        return new ComplexMatrix(newData);
    }

    public static ComplexMatrix identity(int aSize) {
    	Complex[][] data = new Complex[aSize][aSize];
        for ( int row = 0; row < aSize; row++ ) {
        	for ( int col = 0; col < aSize; col++ ) {
        		data[row][col] = ( row == col ) ? new Complex(1, 0) : new Complex(0, 0);
        	}
        }
        return new ComplexMatrix(data);
    }

    public boolean equals(ComplexMatrix aOther) {    	
        if ( aOther.rowCount != rowCount || aOther.colCount != colCount ) {
        	return false;
        }
        for ( int row = 0; row < rowCount; row++ ) {
            for ( int col = 0; col < colCount; col++ ) {
            	if ( data[row][col].subtract(aOther.data[row][col]).modulus() > EPSILON ) {
                	return false;
                }
            }
        }
        return true;
    }

    public void display() {
        for ( int row = 0; row < rowCount; row++ ) {
        	System.out.print("[");
            for ( int col = 0; col < colCount - 1; col++ ) {
                System.out.print(data[row][col] + ", ");
            }
            System.out.println(data[row][colCount - 1] + " ]");
        }
    }

    public boolean isHermitian() {
    	return equals(conjugateTranspose());
    }

    public boolean isNormal() {
    	ComplexMatrix conjugateTranspose = conjugateTranspose();
    	return multiply(conjugateTranspose).equals(conjugateTranspose.multiply(this));
    }

    public boolean isUnitary() {
    	ComplexMatrix conjugateTranspose = conjugateTranspose();
    	return multiply(conjugateTranspose).equals(identity(rowCount)) &&
    		   conjugateTranspose.multiply(this).equals(identity(rowCount));
    }

    private final int rowCount;
    private final int colCount;
    private final Complex[][] data;

    private static final double EPSILON = 0.000_000_000_001;
	
}

final class Complex {
	
	public Complex(double aReal, double aImag) {
		real = aReal;
		imag = aImag;
	}		
	
	public Complex add(Complex aOther) {
		return new Complex(real + aOther.real, imag + aOther.imag);
	}
	
	public Complex multiply(Complex aOther) {
		return new Complex(real * aOther.real - imag * aOther.imag, real * aOther.imag + imag * aOther.real);
	}
	
	public Complex negate() {
		return new Complex(-real, -imag);
	}
	
	public Complex subtract(Complex aOther) {
		return this.add(aOther.negate());
	}
	
	public Complex conjugate() {
		return new Complex(real, -imag);
	}
		
	public double modulus() {
		return Math.hypot(real, imag);
	}
	
	public boolean equals(Complex aOther) {
		return real == aOther.real && imag == aOther.imag;
	}
	
	@Override
	public String toString() {
		String prefix = ( real < 0.0 ) ? "" : " ";
		String realPart = prefix + String.format("%.3f", real);
		String sign = ( imag < 0.0 ) ? " - " : " + ";
		return realPart + sign + String.format("%.3f", Math.abs(imag)) + "i";
	}
	
	private final double real;
	private final double imag;
	
}	
