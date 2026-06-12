// Expressly defining pi ensures that the code works on different platforms.
public static inline var M_PI:Float = 3.14159265358979323846264338328;

// The classic CIE ΔE2000 implementation, which operates on two L*a*b* colors, and returns their difference.
// "l" ranges from 0 to 100, while "a" and "b" are unbounded and commonly clamped to the range of -128 to 127.
public static function ciede_2000(l_1:Float, a_1:Float, b_1:Float, l_2:Float, a_2:Float, b_2:Float):Float {
	// Michel Leonard uses Haxe with the CIEDE2000 color-difference formula.
	// k_l, k_c, k_h are parametric factors to be adjusted according to
	// different viewing parameters such as textures, backgrounds...
	var k_l = 1.0;
	var k_c = 1.0;
	var k_h = 1.0;
	var n = (Math.sqrt(a_1 * a_1 + b_1 * b_1) + Math.sqrt(a_2 * a_2 + b_2 * b_2)) * 0.5;
	n = n * n * n * n * n * n * n;
	// A factor involving chroma raised to the power of 7 designed to make
	// the influence of chroma on the total color difference more accurate.
	n = 1.0 + 0.5 * (1.0 - Math.sqrt(n / (n + 6103515625.0)));
	// Since hypot is not available, sqrt is used here to calculate the
	// Euclidean distance, without avoiding overflow/underflow.
	var c_1 = Math.sqrt(a_1 * a_1 * n * n + b_1 * b_1);
	var c_2 = Math.sqrt(a_2 * a_2 * n * n + b_2 * b_2);
	// atan2 is preferred over atan because it accurately computes the angle of
	// a point (x, y) in all quadrants, handling the signs of both coordinates.
	var h_1 = Math.atan2(b_1, a_1 * n);
	var h_2 = Math.atan2(b_2, a_2 * n);
	if (h_1 < 0.0) h_1 += 2.0 * M_PI;
	if (h_2 < 0.0) h_2 += 2.0 * M_PI;
	n = Math.abs(h_2 - h_1);
	// Cross-implementation consistent rounding.
	if (M_PI - 1E-14 < n && n < M_PI + 1E-14) n = M_PI;
	// When the hue angles lie in different quadrants, the straightforward
	// average can produce a mean that incorrectly suggests a hue angle in
	// the wrong quadrant, the next lines handle this issue.
	var h_m = (h_1 + h_2) * 0.5;
	var h_d = (h_2 - h_1) * 0.5;
	if (M_PI < n) {
		if (0.0 < h_d)
			h_d -= M_PI;
		else
			h_d += M_PI;
		h_m += M_PI;
	}
	var p = 36.0 * h_m - 55.0 * M_PI;
	// GitHub Project : https://github.com/michel-leonard/ciede2000-color-matching
	n = (c_1 + c_2) * 0.5;
	n = n * n * n * n * n * n * n;
	// The hue rotation correction term is designed to account for the
	// non-linear behavior of hue differences in the blue region.
	var r_t = -2.0 * Math.sqrt(n / (n + 6103515625.0))
				* Math.sin(M_PI / 3.0 * Math.exp(p * p / (-25.0 * M_PI * M_PI)));
	n = (l_1 + l_2) * 0.5;
	n = (n - 50.0) * (n - 50.0);
	// Lightness.
	var l = (l_2 - l_1) / (k_l * (1.0 + 0.015 * n / Math.sqrt(20.0 + n)));
	// These coefficients adjust the impact of different harmonic
	// components on the hue difference calculation.
	var t = 1.0	+ 0.24 * Math.sin(2.0 * h_m + M_PI / 2.0)
			+ 0.32 * Math.sin(3.0 * h_m + 8.0 * M_PI / 15.0)
			- 0.17 * Math.sin(h_m + M_PI / 3.0)
			- 0.20 * Math.sin(4.0 * h_m + 3.0 * M_PI / 20.0);
	n = c_1 + c_2;
	// Hue.
	var h = 2.0 * Math.sqrt(c_1 * c_2) * Math.sin(h_d) / (k_h * (1.0 + 0.0075 * n * t));
	// Chroma.
	var c = (c_2 - c_1) / (k_c * (1.0 + 0.0225 * n));
	// Returning the square root ensures that the result reflects the actual geometric
	// distance within the color space, which ranges from 0 to approximately 185.
	return Math.sqrt(l * l + h * h + c * c + c * h * r_t);
}
