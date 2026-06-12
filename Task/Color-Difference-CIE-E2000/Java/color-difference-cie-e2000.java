import java.util.List;

public final class ColorDiffrenceCIE_ΔE2000 {
	
	public static void main(String[] args) {
		List<List<Double>> tests = List.of(
		    List.of( 73.0,   49.0,   39.4, 73.0,   49.0,   39.4 ),
		    List.of( 30.0,  -41.0, -119.1, 30.0,  -41.0, -119.0 ),
		    List.of( 79.0, -117.0, -100.4, 79.5, -117.0, -100.0 ),
		    List.of( 15.0,  -55.0,    6.7, 14.0,  -55.0,    7.0 ),
		    List.of( 83.0,   98.0,  -59.5, 85.2,   98.0,  -59.5 ),
		    List.of( 59.0,  -11.0,  -95.0, 56.3,  -11.0,  -95.0 ),
		    List.of( 74.0,   -1.0,   68.6, 81.0,   -1.0,   69.0 ),
		    List.of( 46.4,  125.0,    6.0, 40.0,  125.0,    6.0 ),
		    List.of( 18.0,   -5.0,   68.0, 20.0,    5.0,   82.0 ),
		    List.of( 35.5,  -99.0,  109.0, 25.0,  -99.0,  109.0 ),
		    List.of( 59.0,   77.0,   41.5, 63.3,   77.0,   12.4 ),
		    List.of( 40.0,  -92.0,    7.7, 58.0,  -92.0,   -8.0 ),
		    List.of( 49.0,   -9.0,  -74.5, 51.1,   31.0,   16.0 ),
		    List.of( 88.0, -124.0,   56.0, 97.0,   62.0,  -28.0 ),
		    List.of( 98.0,   75.7,   11.0,  3.0,  -62.0,   11.0 )
		);
		
		System.out.println("   L1 	    a1 	    b1     L2     a2 	  b2       ΔE2000");
		System.out.println("------------------------------------------------------------");
		tests.forEach( test -> System.out.println(String.format("%6.1f   %6.1f  %6.1f %6.1f %6.1f  %6.1f %14.10f",
			test.get(0), test.get(1), test.get(2), test.get(3), test.get(4), test.get(5),
			cie_ΔE2000(test.get(0), test.get(1), test.get(2), test.get(3), test.get(4), test.get(5))))	
		);
	}

	//The classic CIE ΔE2000 implementation, which operates on two L*a*b* colors, and returns their difference.
	private static double cie_ΔE2000(final double l_1, final double a_1, final double b_1,
			                         final double l_2, final double a_2, final double b_2) {		
		// k_l, k_c, k_h are parametric factors to be adjusted according to
		// different viewing parameters such as textures, backgrounds...
		final double k_l = 1.0;
		final double k_c = 1.0;
		final double k_h = 1.0;
		double n = ( Math.hypot(a_1, b_1) + Math.hypot(a_2, b_2) ) * 0.5;
		n = n * n * n * n * n * n * n;
		n = 1.0 + 0.5 * ( 1.0 - Math.sqrt(n / ( n + 6103515625.0 )) );
		// hypot calculates the Euclidean distance while avoiding overflow/underflow.
		final double c_1 = Math.hypot(a_1 * n, b_1);
		final double c_2 = Math.hypot(a_2 * n, b_2);
		// atan2 is preferred over atan because it accurately computes the angle of
		// a point (x, y) in all quadrants, handling the signs of both coordinates.
		double h_1 = Math.atan2(b_1, a_1 * n);
		double h_2 = Math.atan2(b_2, a_2 * n);
		h_1 += 2.0 * Math.PI * Boolean.compare(h_1 < 0.0, false);
		h_2 += 2.0 * Math.PI * Boolean.compare(h_2 < 0.0, false);
		n = Math.abs(h_2 - h_1);
		// Cross-implementation consistent rounding.
		if ( Math.PI - 1E-14 < n && n < Math.PI + 1E-14 ) {
			n = Math.PI;
		}
		// When the hue angles lie in different quadrants, the straightforward
		// average can produce a mean that incorrectly suggests a hue angle in
		// the wrong quadrant, the next lines handle this issue.
		double h_m = ( h_1 + h_2 ) * 0.5;
		double h_d = ( h_2 - h_1 ) * 0.5;
		if ( Math.PI < n ) {
			if ( 0.0 < h_d ) {
				h_d -= Math.PI;
			} else {
				h_d += Math.PI;
			}
			h_m += Math.PI;
		}
		final double p = 36.0 * h_m - 55.0 * Math.PI;
		n = ( c_1 + c_2 ) * 0.5;
		n = n * n * n * n * n * n * n;
		// The hue rotation correction term is designed to account for the
		// non-linear behavior of hue differences in the blue region.
		final double r_t = -2.0 * Math.sqrt(n / ( n + 6103515625.0 ))
				* Math.sin(Math.PI / 3.0 * Math.exp(p * p / ( -25.0 * Math.PI * Math.PI )));
		n = ( l_1 + l_2 ) * 0.5;
		n = ( n - 50.0 ) * ( n - 50.0 );
		// Lightness.
		final double l = ( l_2 - l_1 ) / ( k_l * ( 1.0 + 0.015 * n / Math.sqrt(20.0 + n) ) );
		// These coefficients adjust the impact of different harmonic
		// components on the hue difference calculation.
		final double t = 1.0 + 0.24 * Math.sin(2.0 * h_m + Math.PI * 0.5)
					         + 0.32 * Math.sin(3.0 * h_m + 8.0 * Math.PI / 15.0)
					         - 0.17 * Math.sin(h_m + Math.PI / 3.0)
					         - 0.20 * Math.sin(4.0 * h_m + 3.0 * Math.PI / 20.0);
		n = c_1 + c_2;
		// Hue.
		final double h = 2.0 * Math.sqrt(c_1 * c_2) * Math.sin(h_d) / ( k_h * ( 1.0 + 0.0075 * n * t ) );
		// Chroma.
		final double c = ( c_2 - c_1 ) / ( k_c * ( 1.0 + 0.0225 * n ) );
		// Returning the square root ensures that the result represents
		// the "true" geometric distance in the color space.
		return Math.sqrt(l * l + h * h + c * c + c * h * r_t);
	}
	
}
