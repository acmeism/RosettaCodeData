import java.util.Arrays;

public final class RootsOfACubicPolynomial {

	public static void main(String[] args) {
		final double r = 1.0 / Math.sqrt(2.0); // = sin(45°) ≈ 0.7071067811865475
		double[][][] matrices = { { {  1, -1,  0 }, {  0,  1,  1 }, {  0,  0,  1 } },
		                          { { -2, -4,  2 }, { -2,  1,  2 }, {  4,  2,  5 } },
		                          { {  1, -1,  0 }, {  0,  1, -1 }, {  0,  0,  1 } },
		                          { {  2,  0,  0 }, {  0, -1,  0 }, {  0,  0, -1 } },
		                          { {  2,  0,  0 }, {  0,  3,  4 }, {  0,  4,  9 } },
		                          { {  1,  0,  0 }, {  0,  r, -r }, {  0,  r,  r } } };
		
		for ( double[][] matrix : matrices ) {
			double[] polynomial = characteristicPolynomial(matrix);
			Complex[][] spectrum = spectrum(polynomial);
			
			System.out.println("Matrix: " + Arrays.deepToString(matrix));
			System.out.println("Characteristic Polynomial coefficients: " + Arrays.toString(polynomial));
			System.out.println("Eigenvalues: " + Arrays.toString(spectrum[0]));
			System.out.println("Errors: " + Arrays.toString(spectrum[1]));
			System.out.println();
		}
	}
	
	private static double[] characteristicPolynomial(double[][] matrix) {
		final double a = 1.0;
        final double b = -matrix[0][0] - matrix[1][1] - matrix[2][2]; // = -trace
        final double c =
        	  ( matrix[0][0] * matrix[1][1] + matrix[1][1] * matrix[2][2] + matrix[2][2] * matrix[0][0] )
            - ( matrix[1][2] * matrix[2][1] + matrix[2][0] * matrix[0][2] + matrix[0][1] * matrix[1][0] );
        final double d = - matrix[0][0] * matrix[1][1] * matrix[2][2]
                         - matrix[0][1] * matrix[1][2] * matrix[2][0]
                         - matrix[0][2] * matrix[1][0] * matrix[2][1]
                         + matrix[0][0] * matrix[2][1] * matrix[1][2]
                         + matrix[0][1] * matrix[1][0] * matrix[2][2]
                         + matrix[0][2] * matrix[1][1] * matrix[2][0]; // = -determinant
        return new double[] { a, b, c, d };
	}
	
	private static Complex[][] spectrum(double[] cubic) {
		if ( cubic.length != 4 || cubic[0] == 0.0 ) {
			throw new AssertionError("Not the coefficients of a cubic: " + cubic);
		}	
		
		final double a = cubic[0], b = cubic[1], c = cubic[2], d = cubic[3];
		double[] reduced = reduce(a, b, c, d);		
		Complex[] solution = solveCubic(a, b, reduced);
		Complex[] errors = errors(solution, cubic);
		
		return new Complex[][] { solution, errors };
	}
	
	private static Complex[] solveCubic(double a, double b, double[] reduced) {
		final double delta = reduced[0], p = reduced[1], q = reduced[2],
				     delta0 = reduced[3], delta1 = reduced[4];
		double[] realPartResult = new double[3];
	    if ( Math.abs(delta) < 1e-12 ) { // repeated real roots
	        if ( Math.abs(p) < 1e-12 ) { // a triple repeated real root
	            realPartResult = new double[] { 0, 0, 0 };
	        } else {                     // a double repeated real root
	            final double result12 = -3.0 * q / ( 2.0 * p );
	            realPartResult = new double[] { 3.0 * q / p, result12, result12 };
	        }
	    } else if ( delta > 0 ) {        // three distinct real roots
	        for ( int i = 0; i < 3; i++ ) {
	            realPartResult[i] = 2.0 * Math.sqrt(-p / 3)	* Math.cos(Math.acos(
	            	Math.sqrt(-3 / p) * 3.0 * q / ( 2.0 * p ) ) / 3.0 - 2.0 * Math.PI * i / 3.0 );
	        }
	    } else { // delta < 0            // one real root and two complex conjugate roots
	        Complex g = new Complex(0.0, 0.0);
	        if ( delta0 == 0.0 && delta1 < 0.0 ) {
	            g = new Complex(-Math.pow(-delta1, 1.0 / 3.0), 0.0);
	        } else if ( delta0 < 0.0 && delta1 == 0.0 ) {
	            g = new Complex(-Math.sqrt(-delta0), 0.0);
	        } else {
	        	final double realPart = Math.pow(delta1, 2.0) - 4.0 * Math.pow(delta0, 3.0);
	            Complex s = new Complex(realPart, 0.0).power(1.0 / 2.0);
	        	Complex g1 = new Complex(delta1, 0.0).add(s).scale(1.0 / 2.0).power(1.0 / 3.0);
	        	Complex g2 = new Complex(delta1, 0.0).subtract(s).scale(1.0 / 2.0).power(1.0 / 3.0);
                g = g1.equals( new Complex(0.0, 0.0) ) ? g2 : g1;
	    	}
	
	        Complex z = g.multiply( new Complex(-0.5, Math.sqrt(3.0) / 2.0) );
	        Complex x0 = new Complex(delta0, 0.0).divide(g).add(g).multiply( new Complex(-1.0 / 3.0, 0.0) );
	        Complex x1 = new Complex(delta0, 0.0).divide(z).add(z).multiply( new Complex(-1.0 / 3.0, 0.0) );
	        Complex[] result = new Complex[] { x0, x1, x1.conjugate() };
	        for ( int i = 0; i < 3; i++ ) {
	            result[i] = result[i].subtract( new Complex(b / ( 3.0 * a ), 0.0) );
	        }
	
	        return result;
	    }
	
	    Complex[] result = new Complex[3];
	    for ( int i = 0; i < 3; i++ ) {
	        result[i] = new Complex(realPartResult[i] - b / ( 3.0 * a ), 0.0);
	    }
	
	    return result;
	}	
	
	private static double[] reduce(double a, double b, double c, double d) {
		final double delta = 18.0 * a * b * c * d - 4.0 * b * b * b * d + b * b * c * c
				             - 4.0 * a * c * c * c - 27.0 * a * a * d * d;
		final double p = ( 3.0 * a * c - b * b ) / ( 3.0 * a * a );
		final double q = ( 2.0 * b * b * b - 9.0 * a * b * c + 27.0 * a * a * d ) / ( 27.0 * a * a * a );
		final double delta0 = b * b - 3.0 * a * c;
		final double delta1 = 2.0 * b * b * b - 9.0 * a * b * c + 27.0 * a * a *d;		
		
		return new double[] { delta, p, q, delta0, delta1 };
	}
	
	private static Complex[] errors(Complex[] solutions, double[] cubic) {
		Complex[] coeffs = new Complex[4];
		for ( int i = 0; i < cubic.length; i++ ) {
			coeffs[i] = new Complex(cubic[i], 0.0);
		}
		
	    Complex[] errors = new Complex[3];
        for ( int i = 0; i < solutions.length; i++ ) {
           errors[i] = coeffs[0].multiply(solutions[i]).add(coeffs[1]).multiply(solutions[i]).add(coeffs[2])
        		                .multiply(solutions[i]).add(coeffs[3]);        		
        }

	    return errors;
	}
	
	private static final class Complex {
		
		public Complex(double aReal, double aImag) {
			real = aReal;
			imag = aImag;
		}

		public Complex add(Complex other) {
			return new Complex(real + other.real, imag + other.imag);
		}
		
		public Complex subtract(Complex other) {
			return new Complex(real - other.real, imag - other.imag);
		}
		
		public Complex multiply(Complex other) {
			return new Complex(real * other.real - imag * other.imag, real * other.imag + imag * other.real);
		}
		
		public Complex divide(Complex other) {
			final double rr = real * other.real + imag * other.imag;
			final double ii = imag * other.real - real * other.imag;
			final double norm = other.real * other.real + other.imag * other.imag;
			
			return new Complex(rr / norm, ii / norm);
		}

		public Complex power(double exponent) {
			if ( real == 0.0 && imag == 0.0 ) {
				return ( exponent == 0.0 ) ? new Complex(1.0, 0.0) : new Complex(0.0, 0.0);
			}
			
			final double modulus = Math.hypot(real, imag);
			final double argument = Math.atan2(imag, real);
			final double newMod = Math.pow(modulus, exponent);
			final double newArg = argument * exponent;
			
			return new Complex(newMod * Math.cos(newArg), newMod * Math.sin(newArg));
		}
		
		public Complex scale(double scale) {
			return new Complex(real * scale, imag * scale);
		}
		
		public Complex conjugate() {
			return new Complex(real, -imag);
		}
		
		public boolean equals(Complex other) {
			return real == other.real && imag == other.imag;
		}
		
		public String toString() {
			if ( imag == 0.0 ) {
				if ( Math.abs(real - Math.round(real)) < 1e-12 ) {
					return String.valueOf(Math.round(real));
				}
				return String.valueOf(real);
			}
			
			return "(" + real + " + i" + imag + ")";
		}
		
		private final double real, imag;
		
	}	

}	
