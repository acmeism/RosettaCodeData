import java.util.ArrayList;
import java.util.List;

public class DiscreteFourierTransform {

	public static void main(String[] args) {
		List<Double> original = List.of( 2.0, 3.0, 5.0, 7.0, 11.0 );
		System.out.println("Original sequence: " + original + System.lineSeparator());		
		
		List<Complex> transformed = discreteFourierTransform(original);
		System.out.println("After applying the Discrete Fourier Transform:");
		System.out.println(transformed + System.lineSeparator());
		
		System.out.println("After applying the Inverse Discrete Fourier Transform to the above transform:");
		System.out.println(inverseDiscreteFourierTransform(transformed));
	}
	
	private static List<Complex> discreteFourierTransform(List<Double> original) {
		List<Complex> originalComplex = original.stream().map( i -> new Complex(i, 0.0) ).toList();
	    final int size = originalComplex.size();
	    final double tau = 2.0 * Math.PI;
	    List<Complex> result = new ArrayList<Complex>(size);
	
	    for ( int k = 0; k < size; k++ ) {
	    	result.addLast( new Complex(0.0, 0.0) );
	        for ( int n = 0; n < size; n++ ) {
	        	final double angle = -tau * k * n / size;
	        	Complex temp = new Complex(Math.cos(angle), Math.sin(angle));
	            result.set(k, result.get(k).add(temp.multiply(originalComplex.get(n))));
	        }
	    }
	    return result;
	}
	
	private static List<Complex> inverseDiscreteFourierTransform(List<Complex> transformed) {
	    final int size = transformed.size();
	    final double tau = 2.0 * Math.PI;
	    List<Complex> result = new ArrayList<Complex>(size);
	
	    for ( int n = 0; n < size; n++ ) {
	        result.addLast( new Complex(0.0, 0.0) );
	        for ( int k = 0; k < size; k++ ) {
	        	final double angle = tau * k * n / size;
	        	Complex temp = new Complex(Math.cos(angle), Math.sin(angle));
	            result.set(n, result.get(n).add(transformed.get(k).multiply(temp)));
	        }
	        result.set(n, result.get(n).divide( new Complex(size, 0.0) ));
	    }
	    return clean(result);
	}
	
	private static List<Complex> clean(List<Complex> list) {
		List<Complex> clean = new ArrayList<Complex>(list.size());
		
		list.forEach( element -> {
			final double real = element.real();
			final double cleanReal = ( Math.abs(real - Math.round(real)) < 1e-12 ) ? Math.round(real) : real;
			final double imag = element.imag();
			final double cleanImag = ( Math.abs(imag - Math.round(imag)) < 1e-12 ) ? Math.round(imag) : imag;
			clean.addLast( new Complex(cleanReal, cleanImag) );
		} );		
		return clean;
	}
	
}

final class Complex {
	
	public Complex(double aReal, double aImag) {
		real = aReal;
		imag = aImag;
	}

	public Complex add(Complex other) {
		return new Complex(real + other.real, imag + other.imag);
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
	
	public double real() {
		return real;
	}
	
	public double imag() {
		return imag;
	}

	public String toString() {
		if ( imag == 0.0 ) {
			return String.valueOf(real);
		}
		return "(" + real + " + i" + imag + ")";
	}
	
	private final double real, imag;
	
}	
