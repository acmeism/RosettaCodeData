import kotlin.math.*

// The classic CIE ΔE2000 implementation, which operates on two L*a*b* colors, and returns their difference.
fun ciede_2000(l_1: Double, a_1: Double, b_1: Double, l_2: Double, a_2: Double, b_2: Double): Double {
	// Michel Leonard uses Kotlin with the CIEDE2000 color-difference formula.
	// k_l, k_c, k_h are parametric factors to be adjusted according to
	// different viewing parameters such as textures, backgrounds...
	val k_l = 1.0;
	val k_c = 1.0;
	val k_h = 1.0;
	var n = (hypot(a_1, b_1) + hypot(a_2, b_2)) * 0.5;
	n = n * n * n * n * n * n * n;
	// GitHub Project :
	// https://github.com/michel-leonard/ciede2000-color-matching
	n = 1.0 + 0.5 * (1.0 - sqrt(n / (n + 6103515625.0)));
	// hypot calculates the Euclidean distance while avoiding overflow/underflow.
	val c_1 = hypot(a_1 * n, b_1);
	val c_2 = hypot(a_2 * n, b_2);
	// atan2 is preferred over atan because it accurately computes the angle of
	// a point (x, y) in all quadrants, handling the signs of both coordinates.
	var h_1 = atan2(b_1, a_1 * n);
	var h_2 = atan2(b_2, a_2 * n);
	if (h_1 < 0.0)
		h_1 += 2.0 * PI;
	if (h_2 < 0.0)
		h_2 += 2.0 * PI;
	n = abs(h_2 - h_1);
	// Cross-implementation consistent rounding.
	if (PI - 1E-14 < n && n < PI + 1E-14)
		n = PI;
	// When the hue angles lie in different quadrants, the straightforward
	// average can produce a mean that incorrectly suggests a hue angle in
	// the wrong quadrant, the next lines handle this issue.
	var h_m = (h_1 + h_2) * 0.5;
	var h_d = (h_2 - h_1) * 0.5;
	if (PI < n) {
		if (0.0 < h_d)
			h_d -= PI;
		else
			h_d += PI;
		h_m += PI;
	}
	val p = 36.0 * h_m - 55.0 * PI;
	n = (c_1 + c_2) * 0.5;
	n = n * n * n * n * n * n * n;
	// The hue rotation correction term is designed to account for the
	// non-linear behavior of hue differences in the blue region.
	val r_t = -2.0 * sqrt(n / (n + 6103515625.0)) * sin(PI / 3.0 * exp((p * p) / (-25.0 * PI * PI)));
	n = (l_1 + l_2) * 0.5;
	n = (n - 50.0) * (n - 50.0);
	// Lightness.
	val l = (l_2 - l_1) / (k_l * (1.0 + 0.015 * n / sqrt(20.0 + n)));
	// These coefficients adjust the impact of different harmonic
	// components on the hue difference calculation.
	val t = 1.0 +	0.24 * sin(2.0 * h_m + PI * 0.5) +
			0.32 * sin(3.0 * h_m + 8.0 * PI / 15.0) -
			0.17 * sin(h_m + PI / 3.0) -
			0.20 * sin(4.0 * h_m + 3.0 * PI / 20.0);
	n = c_1 + c_2;
	// Hue.
	val h = 2.0 * sqrt(c_1 * c_2) * sin(h_d) / (k_h * (1.0 + 0.0075 * n * t));
	// Chroma.
	val c = (c_2 - c_1) / (k_c * (1.0 + 0.0225 * n));
	// Returning the square root ensures that the result represents
	// the "true" geometric distance in the color space.
	return sqrt(l * l + h * h + c * c + c * h * r_t);
}

fun main(args: Array<String>)
{
    val tests = arrayOf( arrayOf(73.0,   49.0,   39.4, 73.0,   49.0,   39.4)
                       , arrayOf(30.0,  -41.0, -119.1, 30.0,  -41.0, -119.0)
                       , arrayOf(79.0, -117.0, -100.4, 79.5, -117.0, -100.0)
                       , arrayOf(15.0,  -55.0,    6.7, 14.0,  -55.0,    7.0)
                       , arrayOf(83.0,   98.0,  -59.5, 85.2,   98.0,  -59.5)
                       , arrayOf(59.0,  -11.0,  -95.0, 56.3,  -11.0,  -95.0)
                       , arrayOf(74.0,   -1.0,   68.6, 81.0,   -1.0,   69.0)
                       , arrayOf(46.4,  125.0,    6.0, 40.0,  125.0,    6.0)
                       , arrayOf(18.0,   -5.0,   68.0, 20.0,    5.0,   82.0)
                       , arrayOf(35.5,  -99.0,  109.0, 25.0,  -99.0,  109.0)
                       , arrayOf(59.0,   77.0,   41.5, 63.3,   77.0,   12.4)
                       , arrayOf(40.0,  -92.0,    7.7, 58.0,  -92.0,   -8.0)
                       , arrayOf(49.0,   -9.0,  -74.5, 51.1,   31.0,   16.0)
                       , arrayOf(88.0, -124.0,   56.0, 97.0,   62.0,  -28.0)
                       , arrayOf(98.0,   75.7,   11.0,  3.0,  -62.0,   11.0)
                       );

    println("   L1 	    a1 	    b1     L2     a2 	  b2       ΔE2000");
    println("------------------------------------------------------------");
    val f = "%6.1f   %6.1f  %6.1f %6.1f %6.1f  %6.1f %14.10f"
    repeat(tests.size) { i ->
                         val t = tests[i];
                         val res = ciede_2000(t[0], t[1], t[2], t[3], t[4], t[5]);
                         println(f.format(    t[0], t[1], t[2], t[3], t[4], t[5], res))
    }
}
