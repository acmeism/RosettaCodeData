import java.awt.Point;
import java.util.Arrays;

public final class LagrangeInterpolation {

	public static void main(String[] args) {
		Point[] points = new Point[] { new Point(1, 1), new Point(2, 4), new Point(3, 1), new Point(4, 5) };
		
		display(lagrangeInterpolation(points));
	}
	
	private static double[] lagrangeInterpolation(Point[] points) {
	    double[][] polys = new double[points.length][points.length];
	    for ( int i = 0; i < points.length; i++ ) {
	        double[] poly = new double[] { 1.0 };
	        for ( int j = 0; j < points.length; j++ ) {
	            if ( i != j ) {
	            	poly = multiply(poly, new double[] { -points[j].x, 1.0 });
	            }
	        }
	        final double value = evaluate(poly, points[i].x);
	        polys[i] = scalarDivide(poly, value);
	    }
	
	    double[] sum = new double[] { 0.0 };
 	    for ( int i = 0; i < points.length; i++ ) {
	        polys[i] = scalarMultiply(polys[i], points[i].y);
	        sum = add(sum, polys[i]);
	    }
	    return sum;
	}

	// A double[] is used to represents a Polynomial
	// with its coefficients reversed compared to the standard mathematical notation.
	// For example, the polynomial 3x^2 + 2x + 1 is represented by the array [1, 2, 3].
	private static double[] add(double[] one, double[] two) {
		double[] sum = Arrays.copyOf(one, Math.max(one.length, two.length));
	    for ( int i = 0; i < two.length; i++ ) {
	    	sum[i] += two[i];
	    }
	    return sum;
	}
	
	private static double[] multiply(double[] one, double[] two) {
	    double[] product = new double[one.length + two.length - 1];
	    for ( int i = 0; i < one.length; i++ ) {
	        for ( int j = 0; j < two.length; j++ ) {
	        	product[i + j] += one[i] * two[j];
	        }
	    }
	    return product;
	}
	
	private static double[] scalarMultiply(double[] array, double value) {
		return Arrays.stream(array).map( d -> d * value ).toArray();
	}
	
	private static double[] scalarDivide(double[] array, double value) {
		return scalarMultiply(array, 1.0 / value);
	}
	
	private static double evaluate(double[] array, double value) {
	    double result = 0.0;
	    for ( int i = array.length - 1; i >= 0; i-- ) {
	        result = result * value + array[i];
	    }	
	    return result;
	}
	
	private static void display(double[] array) {
		final int degree = array.length - 1;
        if ( degree == 0 ) {
        	System.out.println(String.format("%2.5f", array[0]));
        	return;
        }

        for ( int i = degree; i >= 0; i-- ) {
        	if ( array[i] == 0.0 ) {
        		continue;
        	}
        	String sign = ( array[i] < 0.0 && i == degree ) ?
        		"-" : ( array[i] < 0.0 ) ? " - " : ( i < degree ) ? " + " : "";
        	System.out.print(sign);
        	final double coeff = Math.abs(array[i]);
        	if ( coeff > 1.0 ) {
        		System.out.print(String.format("%2.5f", coeff));
        	}
        	String term = ( i > 1 ) ? "x^" + String.valueOf(i) : ( i == 1 ) ?
        		"x" : ( coeff == 1.0 ) ? "1" : "";
        	System.out.print(term);
        }
        System.out.println();
    }

}

