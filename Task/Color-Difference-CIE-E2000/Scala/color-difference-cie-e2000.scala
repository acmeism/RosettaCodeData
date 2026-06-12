import scala.math._

// The classic CIE ΔE2000 implementation, which operates on two L*a*b* colors, and returns their difference.
// "l" ranges from 0 to 100, while "a" and "b" are unbounded and commonly clamped to the range of -128 to 127.
def ciede_2000(l_1: Double, a_1: Double, b_1: Double, l_2: Double, a_2: Double, b_2: Double): Double = {
	// Michel Leonard uses Scala with the CIEDE2000 color-difference formula.
	// k_l, k_c, k_h are parametric factors to be adjusted according to
	// different viewing parameters such as textures, backgrounds...
	val k_l: Double = 1.0
	val k_c: Double = 1.0
	val k_h: Double = 1.0
	var n: Double = (sqrt(a_1 * a_1 + b_1 * b_1) + sqrt(a_2 * a_2 + b_2 * b_2)) * 0.5
	n = n * n * n * n * n * n * n
	// A factor involving chroma raised to the power of 7 designed to make
	// the influence of chroma on the total color difference more accurate.
	n = 1.0 + 0.5 * (1.0 - sqrt(n / (n + 6103515625.0)))
	// The hypot function can do the following, but is not required here.
	val c_1: Double = sqrt(a_1 * a_1 * n * n + b_1 * b_1)
	val c_2: Double = sqrt(a_2 * a_2 * n * n + b_2 * b_2)
	// atan2 is preferred over atan because it accurately computes the angle of
	// a point (x, y) in all quadrants, handling the signs of both coordinates.
	var h_1: Double = atan2(b_1, a_1 * n)
	var h_2: Double = atan2(b_2, a_2 * n)
	if (h_1 < 0.0)
		h_1 += 2.0 * scala.math.Pi
	if (h_2 < 0.0)
		h_2 += 2.0 * scala.math.Pi
	n = abs(h_2 - h_1)
	// Cross-implementation consistent rounding.
	if (scala.math.Pi - 1E-14 < n && n < scala.math.Pi + 1E-14)
		n = scala.math.Pi
	// When the hue angles lie in different quadrants, the straightforward
	// average can produce a mean that incorrectly suggests a hue angle in
	// the wrong quadrant, the next lines handle this issue.
	var h_m: Double = (h_1 + h_2) * 0.5
	var h_d: Double = (h_2 - h_1) * 0.5
	// GitHub Project : https://github.com/michel-leonard/ciede2000-color-matching
	if (scala.math.Pi < n) {
		if (0.0 < h_d)
			h_d -= scala.math.Pi
		else
			h_d += scala.math.Pi
		h_m += scala.math.Pi
	}
	val p: Double = 36.0 * h_m - 55.0 * scala.math.Pi
	n = (c_1 + c_2) * 0.5
	n = n * n * n * n * n * n * n
	// The hue rotation correction term is designed to account for the
	// non-linear behavior of hue differences in the blue region.
	val r_t: Double = -2.0 * sqrt(n / (n + 6103515625.0)) *
		sin(scala.math.Pi / 3.0 * exp(p * p / (-25.0 * scala.math.Pi * scala.math.Pi)))
	n = (l_1 + l_2) * 0.5
	n = (n - 50.0) * (n - 50.0)
	// Lightness.
	val l: Double = (l_2 - l_1) / (k_l * (1.0 + 0.015 * n / sqrt(20.0 + n)))
	// These coefficients adjust the impact of different harmonic
	// components on the hue difference calculation.
	val t:Double = 1.0 +	0.24 * sin(2.0 * h_m + scala.math.Pi / 2.0) +
				0.32 * sin(3.0 * h_m + 8.0 * scala.math.Pi / 15.0) -
				0.17 * sin(h_m + scala.math.Pi / 3.0) -
				0.20 * sin(4.0 * h_m + 3.0 * scala.math.Pi / 20.0)
	n = c_1 + c_2
	// Hue.
	val h: Double = 2.0 * sqrt(c_1 * c_2) * sin(h_d) / (k_h * (1.0 + 0.0075 * n * t))
	// Chroma.
	val c: Double = (c_2 - c_1) / (k_c * (1.0 + 0.0225 * n))
	// Returns the square root so that the DeltaE 2000 reflects the actual geometric
	// distance within the color space, which ranges from 0 to approximately 185.
	sqrt(l * l + h * h + c * c + c * h * r_t)
}
