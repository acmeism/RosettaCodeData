import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Paths;
import java.util.ArrayList;
import java.util.Collections;
import java.util.Comparator;
import java.util.List;

public final class GaussianPrimes {

	public static void main(String[] args) throws IOException {
		List<Complex> gaussianPrimes = createGaussianPrimes(10);		
		System.out.println("Gaussian primes less than radius 10 from the origin:");
		for ( int i = 0; i < gaussianPrimes.size(); i++ ) {
			System.out.print(String.format("%s%s", gaussianPrimes.get(i), ( i % 10 == 9 ? "\n" : "  " )));
		}
			
		String text = svgFileText(createGaussianPrimes(50), 1000);
    	Files.write(Paths.get("GaussianPrimesJava.svg"), text.getBytes());
	}
	
	private static List<Complex> createGaussianPrimes(int limit) {
		List<Complex> result = new ArrayList<Complex>();
		for ( int real = -limit; real <= limit; real++ ) {
			for ( int imag = -limit; imag <= limit; imag++ ) {
				Complex number = new Complex(real, imag);
				if ( number.norm() < limit * limit && number.isGaussianPrime() ) {
					result.addLast(number);
				}
			}
		}
		
		Collections.sort(result, Comparator.comparing(Complex::norm)
                						   .thenComparing(Complex::real)
                						   .thenComparing(Complex::imag));
		return result;
	}
	
	private static String svgFileText(List<Complex> numbers, int size) {
    	StringBuilder text = new StringBuilder();
    	text.append("<svg xmlns='http://www.w3.org/2000/svg'");
    	text.append(" width='" + size + "' height='" + size + "'>\n");
        text.append("<rect style='width:100%; height:100%; fill:cyan' />\n");
        text.append("<line x1='0' y1='500' x2='1000' y2='500' style='stroke:black; stroke-width:2' />");
        text.append("<line x1='500' y1='0' x2='500' y2='1000' style='stroke:black; stroke-width:2' />");
        for ( Complex number : numbers ) {
        	 text.append("<circle cx='" + ( 500 + 8 * number.real() ) + "'");
        	 text.append(" cy='" + ( 500 + 8 * number.imag() )  + "'");
        	 text.append(" r='4' stroke='black' stroke-width='2' fill='yellow' />");
        }
        text.append("</svg>");
        return text.toString();
    }
	
}

final class Complex {
	
	public Complex(int aReal, int aImag) {
		real = aReal;
		imag = aImag;
	}		

	public int norm() {
		return real * real + imag * imag;
	}
	
	public boolean isGaussianPrime() {
		final int r = Math.abs(real);
		final int c = Math.abs(imag);
		return isRealPrime(r * r + c * c)	
			   || c == 0 && isRealPrime(r) && ( r - 3 ) % 4 == 0
			   || r == 0 && isRealPrime(c) && ( c - 3 ) % 4 == 0;
	}

	@Override
	public String toString() {
		String prefix = ( real < 0 ) ? "" : " ";
		String realPart = prefix + real;
		String sign = ( imag < 0 ) ? " - " : " + ";
		return realPart + sign + Math.abs(imag) + "i";
	}
	
	public int real() {
		return real;
	}
	
	public int imag() {
		return imag;
	}
	
	private boolean isRealPrime(int number) {
		if ( number < 2 ) { return false; }
		if ( number % 2 == 0 ) { return number == 2; }
		if ( number % 3 == 0 ) { return number == 3; }

		for ( int divisor = 5; divisor * divisor <= number; divisor += 2 ) {
			if ( number % divisor == 0 ) { return false; }
		}		
		return true;
	}
	
	private final int real;
	private final int imag;
	
}	
