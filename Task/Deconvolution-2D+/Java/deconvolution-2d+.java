import java.util.Arrays;

public final class Deconvolution {
		
	public static void main(String[] args) {		
	    final int[] f1 = { -3, -6, -1, 8, -6, 3, -1, -9, -9, 3, -2, 5, 2, -2, -7, -1 };
	
	    final int[] g1 =
	    	{ 24, 75, 71, -34, 3, 22, -45, 23, 245, 25, 52, 25, -67, -96, 96, 31, 55, 36, 29, -43, -7 };
	
	    final int[] h1 = { -8, -9, -3, -1, -6, 7 };		

		final int[][] f2 = { { -5,  2, -2, -6, -7 },
				             {  9,  7, -6,  5, -7 },
				             {  1, -1,  9,  2, -7 },
				             {  5,  9, -9,  2, -5 },
				             { -8,  5, -2,  8,  5 } };
		
		final int[][] g2 = { {   40,  -21,   53,   42,  105,    1,   87,   60,   39,   -28 },
							 {  -92,  -64,   19, -167,  -71,  -47,  128, -109,   40,   -21 },
							 {   58,   85,  -93,   37,  101,  -14,    5,   37,  -76,   -56 },
							 {  -90, -135,   60, -125,   68,   53,  223,    4,  -36,   -48 },
							 {   78,   16,    7, -199,  156, -162,   29,   28, -103,   -10 },
							 {  -62,  -89,   69,  -61,   66,  193,  -61,   71,   -8,   -30 },
							 {   48,   -6,   21,   -9, -150,  -22,  -56,   32,   85,    25 } };
		
		final int[][] h2 = { { -8,  1, -7, -2, -9,  4 },
                             {  4,  5, -5,  2,  7, -1 },
                             { -6, -3, -3, -6,  9,  5 } };
		
		final int[][][] f3 = { { { -9,  5, -8 }, {  3,  5,  1 } },
		                       { { -1, -7,  2 }, { -5, -6,  6 } },
		                       { {  8,  5,  8 }, { -2, -6, -4 } } };
		
		final int[][][] g3 = { { {   54,   42,   53,  -42,   85,  -72 },
		                         {   45, -170,   94,  -36,   48,   73 },
		                         {  -39,   65, -112,  -16,  -78,  -72 },
		                         {    6,  -11,   -6,   62,   49,    8 } },
		                       { {  -57,   49,  -23,   52, -135,   66 },
		                         {  -23,  127,  -58,   -5, -118,   64 },
		                         {   87,  -16,  121,   23,  -41,  -12 },
		                         {  -19,   29,   35, -148,  -11,   45 } },
		                       { {  -55, -147, -146,  -31,   55,   60 },
		                         {  -88,  -45,  -28,   46,  -26, -144 },
		                         {  -12, -107,  -34,  150,  249,   66 },
		                         {   11,  -15,  -34,   27,  -78,  -50 } },
		                       { {   56,   67,  108,    4,    2,  -48 },
		                         {   58,   67,   89,   32,   32,   -8 },
		                         {  -42,  -31, -103,  -30,  -23,   -8 },
		                         {    6,    4,  -26,  -10,   26,   12 } } };
		
		final int[][][] h3 = { { { -6, -8, -5,  9 },
		                         { -7,  9, -6, -8 },
		                         {  2, -7,  9,  8 } },
		                       { {  7,  4,  4, -6 },
		                         {  9,  9,  4, -4 },
		                         { -3,  7, -2, -3 } } };
		
		int[] H1 = deconvolution1D(g1, f1);		
		System.out.println("deconvolution1D(g1, f1) = " + Arrays.toString(H1));		
		System.out.println("H1 = h1 ? " + Arrays.equals(H1, h1));
		System.out.println();
	
		int[] F1 = deconvolution1D(g1, h1);
		System.out.println("deconvolution1D(g1, h1) = " + Arrays.toString(F1));		
		System.out.println("F1 = f1 ? " + Arrays.equals(F1, f1));
		System.out.println();
	
		int[][] H2 = deconvolution2D(g2, f2);
		System.out.println("deconvolution2D(g2, f2) = " + Arrays.deepToString(H2));		
		System.out.println("H2 = h2 ? " + Arrays.deepEquals(H2, h2));
		System.out.println();
		
		int[][] F2 = deconvolution2D(g2, h2);
		System.out.println("deconvolution2D(g2, h2) = " + Arrays.deepToString(F2));		
		System.out.println("F2 = f2 ? " + Arrays.deepEquals(F2, f2));
		System.out.println();
		
		int[][][] H3 = deconvolution3D(g3, f3);
		System.out.println("deconvolution3D(g3, f3) = " + Arrays.deepToString(H3));		
		System.out.println("H3 = h3 ? " + Arrays.deepEquals(H3, h3));
		System.out.println();
		
		int[][][] F3 = deconvolution3D(g3, h3);		
		System.out.println("deconvolution3D(g3, h3) = " + Arrays.deepToString(F3));		
		System.out.println("F3 = f3 ? " + Arrays.deepEquals(F3, f3));
	}
	
	private static int[] deconvolution1D(int[] convolved, int[] toRemove) {
		return deconvolution(convolved, convolved.length, toRemove, toRemove.length,
							 1 , convolved.length - toRemove.length + 1);
	}
	
	private static int[][] deconvolution2D(int[][] convolved, int[][] toRemove) {
	    int[] convolvedArray = unpack2D(convolved, convolved[0].length);
	    int[] toRemoveArray = unpack2D(toRemove, convolved[0].length);
	    int[] toRemainArray = deconvolution(convolvedArray, convolved.length * convolved[0].length,
	    									toRemoveArray, toRemove.length * convolved[0].length,
	    	convolved[0].length, ( convolved[0].length - toRemove[0].length + 1 ) * convolved[0].length);
	
	    return pack2D(toRemainArray, convolved.length - toRemove.length + 1,
	    		      convolved[0].length - toRemove[0].length + 1, convolved[0].length);
	}
	
	private static int[][][] deconvolution3D(int[][][] convolved, int[][][] toRemove) {
		final int cX = convolved.length;
		final int cY = convolved[0].length;
		final int cZ = convolved[0][0].length;
		
		final int rX = toRemove.length;
		final int rY = toRemove[0].length;
		final int rZ = toRemove[0][0].length;		
		
	    int[] convolvedArray = unpack3D(convolved, cY, cZ);
	    int[] toRemoveArray = unpack3D(toRemove, cY, cZ);
	    int[] toRemainArray = deconvolution(convolvedArray, cX * cY * cZ,
	    	toRemoveArray, rX * cY * cZ, cY * cZ, ( cX - rX + 1 ) * cY * cZ);
	
	    return pack3D(toRemainArray, cX - rX + 1, cY - rY + 1, cZ - rZ + 1, cY, cZ);
	}
	
	private static int[] deconvolution(int[] convolvedArray, int convolvedLength,
			                           int[] toRemoveArray, int toRemoveLength,
			                           int convolvedRowLength, int toRemainLength) {
		
	    int powerOfTwo = 0;
	    ReturnValue convolvedResult = padAndComplexify(convolvedArray, powerOfTwo);
	    Complex[] convolvedPadded = convolvedResult.array;
	    ReturnValue toRemoveResult = padAndComplexify(toRemoveArray, convolvedResult.powerOfTwo);
	    Complex[] toRemovePadded = toRemoveResult.array;
	    powerOfTwo = toRemoveResult.powerOfTwo;
	
	    fft(convolvedPadded, powerOfTwo);
	    fft(toRemovePadded, powerOfTwo);
	    Complex[] quotient = new Complex[powerOfTwo];
	    for ( int i = 0; i < powerOfTwo; i++ ) {
	    	quotient[i] = convolvedPadded[i].divide(toRemovePadded[i]);
	    }
	
	    fft(quotient, powerOfTwo);
	    for ( int i = 0; i < powerOfTwo; i++ ) {
	        if ( Math.abs(quotient[i].real()) < 0.000_000_000_1 ) {
	        	quotient[i] = Complex.ZERO;
	        }
	    }
	
	    int[] toRemainArray = new int[toRemainLength];
	    int i = 0;
	    while ( i > toRemoveLength - convolvedLength - convolvedRowLength ) {
	        toRemainArray[-i] = Math.toIntExact(Math.round(
	        	quotient[( i + powerOfTwo ) % powerOfTwo].divide(32).real()));
	        i -= 1;
	    }
	    return toRemainArray;
	}
	
	private static Complex[] fft(Complex[] deconvolution1D, int powerOfTwo) {
	    Complex[] result = Arrays.copyOf(deconvolution1D, deconvolution1D.length);
	    fft(deconvolution1D, result, powerOfTwo, 1, 0);	
	    return result;
	}
	
	private static void fft(Complex[] deconvolution1D, Complex[] result,
						    int powerOfTwo, int step, int start) {
		
	    if ( step < powerOfTwo ) {
	        fft(result, deconvolution1D, powerOfTwo, 2 * step, start); 	
	        fft(result, deconvolution1D, powerOfTwo, 2 * step, start + step);

	        for ( int j = 0; j < powerOfTwo; j += 2 * step ) {
	        	final double theta = -Math.PI * j / powerOfTwo;	        	
	        	Complex t = new Complex(Math.cos(theta), Math.sin(theta)).multiply(result[j + step + start]);	        	
	            deconvolution1D[( j / 2 ) + start]                  = result[j + start].add(t);
	            deconvolution1D[( ( j + powerOfTwo ) / 2 ) + start] = result[j + start].subtract(t);
	        }
	    }
	}
	
	private static int[] unpack2D(int[][] toUnpack, int convolvedY) {
	    int[] unpacked = new int[toUnpack.length * convolvedY];
	    for ( int i = 0; i < toUnpack.length; i++ ) {
	        for ( int j = 0; j < toUnpack[0].length; j++ ) {
	        	unpacked[i * convolvedY + j] = toUnpack[i][j];
	        }
	    }
	    return unpacked;
	}
	
	private static int[] unpack3D(int[][][] toUnpack, int convolvedY, int convolvedZ) {
	    int[] unpacked = new int[toUnpack.length * convolvedY * convolvedZ];
	    for ( int i = 0; i < toUnpack.length; i++ ) {
	        for ( int j = 0; j < toUnpack[0].length; j++ ) {
	            for ( int k = 0; k < toUnpack[0][0].length; k++ ) {
	                unpacked[( i * convolvedY + j ) * convolvedZ + k] = toUnpack[i][j][k];
	            }
	        }
	    }
	    return unpacked;
	}
	
	private static int[][] pack2D(int[] toPack, int toPackX, int toPackY, int convolvedY) {		
		int[][] packed = new int[toPackX][toPackY];
	    for ( int i = 0; i < toPackX; i++ ) {
	        for ( int j = 0; j < toPackY; j++ ) {
	        	packed[i][j] = toPack[i * convolvedY + j] / 4;
	        }
	    }
	    return packed;
	}
	
	private static int[][][] pack3D(int[] toPack, int toPackX, int toPackY, int toPackZ,
			                        int convolvedY, int convolvedZ) {
		
		int[][][] packed = new int[toPackX][toPackY][toPackZ];
	    for ( int i = 0; i < toPackX; i++ ) {
	        for ( int j = 0; j < toPackY; j++ ) {
	            for ( int k = 0; k < toPackZ; k++ ) {
	                packed[i][j][k] = toPack[( i * convolvedY + j ) * convolvedZ + k] / 4;
	            }
	        }
	    }
		return packed;
	}
		
	private static ReturnValue padAndComplexify(int[] array, int powerOfTwo) {
		final int paddedArrayLength = ( powerOfTwo == 0 ) ?
			Integer.highestOneBit(array.length - 1) << 1 : powerOfTwo;
		
		Complex[] paddedArray = new Complex[paddedArrayLength];
	    for ( int i = 0; i < paddedArrayLength; i++ ) {
	    	paddedArray[i] = ( i < array.length ) ? new Complex(array[i], 0.0) : Complex.ZERO;
	    }
	    return new ReturnValue(paddedArrayLength, paddedArray);
	}
	
	private static record ReturnValue(int powerOfTwo, Complex[] array) {}
	
}

final class Complex {
	
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
		return new Complex(real * other.real - imag * other.imag, imag * other.real + real * other.imag);
	}
	
	public Complex divide(int n) {
		return new Complex(real / n, imag / n);
	}
	
	public Complex divide(Complex other) {
		final double rr = real * other.real + imag * other.imag;
		final double ii = imag * other.real - real * other.imag;
		final double norm = other.real * other.real + other.imag * other.imag;
		return new Complex(rr / norm, ii / norm);
	}
	
	public double real() {
		return real;
	}
	
	public static final Complex ZERO = new Complex(0.0, 0.0);
	
	private final double real;
	private final double imag;
	
}
