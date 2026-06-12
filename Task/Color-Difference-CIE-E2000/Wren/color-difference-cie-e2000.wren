import "./math" for Math
import "./fmt" for Fmt

// The classic CIE ΔE2000 implementation, which operates on two L*a*b* colors, and returns their difference.
var ciede_2000 = Fn.new { |l_1, a_1, b_1, l_2, a_2, b_2|
	// Implements the CIEDE2000 color-difference formula using Wren.
	// k_l, k_c, k_h are parametric factors to be adjusted according to
	// different viewing parameters such as textures, backgrounds...
	var k_l = 1
    var k_c = 1
    var k_h = 1
	var n = (Math.hypot(a_1, b_1) + Math.hypot(a_2, b_2)) * 0.5
	n = n * n * n * n * n * n * n
	// GitHub Project :
	// https://github.com/michel-leonard/ciede2000-color-matching
	n = 1.0 + 0.5 * (1.0 - (n / (n + 6103515625)).sqrt)
	// hypot calculates the Euclidean distance while avoiding overflow/underflow.
	var c_1 = Math.hypot(a_1 * n, b_1)
    var c_2 = Math.hypot(a_2 * n, b_2)
	// atan2 (x.atan(y) in Wren) is preferred over atan because it accurately computes the angle of
	// a point (x, y) in all quadrants, handling the signs of both coordinates.
	var h_1 = b_1.atan(a_1 * n)
    var h_2 = b_2.atan(a_2 * n)
	if (h_1 < 0) h_1 = h_1 + 2 * Num.pi
	if (h_2 < 0) h_2 = h_2 + 2 * Num.pi
	n = (h_2 - h_1).abs
	// Cross-implementation consistent rounding.
	if (Num.pi - 1e-14 < n && n < Num.pi + 1e-14) n = Num.pi
	// When the hue angles lie in different quadrants, the straightforward
	// average can produce a mean that incorrectly suggests a hue angle in
	// the wrong quadrant, the next lines handle this issue.
	var h_m = (h_1 + h_2) * 0.5
    var h_d = (h_2 - h_1) * 0.5
	if (Num.pi < n) {
		if (0 < h_d) {
			h_d = h_d - Num.pi
		} else {
			h_d = h_d + Num.pi
        }
		h_m = h_m + Num.pi
	}
	var p = 36 * h_m - 55 * Num.pi
	n = (c_1 + c_2) * 0.5
	n = n * n * n * n * n * n * n
	// The hue rotation correction term is designed to account for the
	// non-linear behavior of hue differences in the blue region.
	var r_t = -2 * (n / (n + 6103515625.0)).sqrt *
             (Num.pi / 3 * (p * p / (-25 * Num.pi * Num.pi)).exp).sin
	n = (l_1 + l_2) * 0.5
	n = (n - 50) * (n - 50)
	// Lightness.
	var l = (l_2 - l_1) / (k_l * (1 + 0.015 * n / (20 + n).sqrt))
	// These coefficients adjust the impact of different harmonic
	// components on the hue difference calculation.
	var t = 1 + 0.24 * (2 * h_m + Num.pi * 0.5).sin +
				0.32 * (3 * h_m + 8 * Num.pi / 15).sin -
				0.17 * (h_m + Num.pi / 3).sin -
				0.20 * (4 * h_m + 3 * Num.pi / 20).sin
	n = c_1 + c_2
	// Hue.
	var h = 2 * (c_1 * c_2).sqrt * h_d.sin / (k_h * (1 + 0.0075 * n * t))
	// Chroma.
	var c = (c_2 - c_1) / (k_c * (1 + 0.0225 * n))
	// Returning the square root ensures that the result represents
	// the "true" geometric distance in the color space.
	return (l * l + h * h + c * c + c * h * r_t).sqrt
}

var tests = [
    [73.0,   49.0,   39.4, 73.0,   49.0,   39.4],
    [30.0,  -41.0, -119.1, 30.0,  -41.0, -119.0],
    [79.0, -117.0, -100.4, 79.5, -117.0, -100.0],
    [15.0,  -55.0,    6.7, 14.0,  -55.0,    7.0],
    [83.0,   98.0,  -59.5, 85.2,   98.0,  -59.5],
    [59.0,  -11.0,  -95.0, 56.3,  -11.0,  -95.0],
    [74.0,   -1.0,   68.6, 81.0,   -1.0,   69.0],
    [46.4,  125.0,    6.0, 40.0,  125.0,    6.0],
    [18.0,   -5.0,   68.0, 20.0,    5.0,   82.0],
    [35.5,  -99.0,  109.0, 25.0,  -99.0,  109.0],
    [59.0,   77.0, 	 41.5, 63.3,   77.0,   12.4],
    [40.0,  -92.0,    7.7, 58.0,  -92.0,   -8.0],
    [49.0,   -9.0,  -74.5, 51.1,   31.0,   16.0],
    [88.0, -124.0,   56.0, 97.0,   62.0,  -28.0],
    [98.0,   75.7, 	 11.0, 	3.0,  -62.0,   11.0]
]
System.print("   L1 	    a1 	    b1     L2     a2 	  b2       ΔE2000")
System.print("------------------------------------------------------------")
var f = "$6.1f   $6.1f  $6.1f $6.1f $6.1f  $6.1f $14.10f"
for (t in tests) {
    var res = ciede_2000.call(t[0], t[1], t[2], t[3], t[4], t[5])
    Fmt.lprint(f, t + [res])
}
