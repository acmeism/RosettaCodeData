// The classic CIE ΔE2000 implementation, which operates on two L*a*b* colors, and returns their difference.
// "l" ranges from 0 to 100, while "a" and "b" are unbounded and commonly clamped to the range of -128 to 127.
static double ciede_2000(double l_1, double a_1, double b_1, double l_2, double a_2, double b_2) {
	// Michel Leonard uses C# (.NET Core) with the CIEDE2000 color-difference formula.
	// k_l, k_c, k_h are parametric factors to be adjusted according to
	// different viewing parameters such as textures, backgrounds...
	const double k_l = 1.0, k_c = 1.0, k_h = 1.0;
	double n = (Math.Sqrt(a_1 * a_1 + b_1 * b_1) + Math.Sqrt(a_2 * a_2 + b_2 * b_2)) * 0.5;
	n = n * n * n * n * n * n * n;
	// A factor involving chroma raised to the power of 7 designed to make
	// the influence of chroma on the total color difference more accurate.
	n = 1.0 + 0.5 * (1.0 - Math.Sqrt(n / (n + 6103515625.0)));
	// Since hypot is not available, sqrt is used here to calculate the
	// Euclidean distance, without avoiding overflow/underflow.
	double c_1 = Math.Sqrt(a_1 * a_1 * n * n + b_1 * b_1);
	double c_2 = Math.Sqrt(a_2 * a_2 * n * n + b_2 * b_2);
	// atan2 is preferred over atan because it accurately computes the angle of
	// a point (x, y) in all quadrants, handling the signs of both coordinates.
	double h_1 = Math.Atan2(b_1, a_1 * n), h_2 = Math.Atan2(b_2, a_2 * n);
	if (h_1 < 0.0) h_1 += 2.0 * Math.PI;
	if (h_2 < 0.0) h_2 += 2.0 * Math.PI;
	n = Math.Abs(h_2 - h_1);
	// Cross-implementation consistent rounding.
	if (Math.PI - 1E-14 < n && n < Math.PI + 1E-14)
		n = Math.PI;
	// When the hue angles lie in different quadrants, the straightforward
	// average can produce a mean that incorrectly suggests a hue angle in
	// the wrong quadrant, the next lines handle this issue.
	double h_m = (h_1 + h_2) * 0.5, h_d = (h_2 - h_1) * 0.5;
	if (Math.PI < n) {
		if (0.0 < h_d)
			h_d -= Math.PI;
		else
			h_d += Math.PI;
		h_m += Math.PI;
	}
	// GitHub Project : https://github.com/michel-leonard/ciede2000-color-matching
	double p = 36.0 * h_m - 55.0 * Math.PI;
	n = (c_1 + c_2) * 0.5;
	n = n * n * n * n * n * n * n;
	// The hue rotation correction term is designed to account for the
	// non-linear behavior of hue differences in the blue region.
	double r_t = -2.0 * Math.Sqrt(n / (n + 6103515625.0))
			* Math.Sin(Math.PI / 3.0 * Math.Exp(p * p / (-25.0 * Math.PI * Math.PI)));
	n = (l_1 + l_2) * 0.5;
	n = (n - 50.0) * (n - 50.0);
	// Lightness.
	double l = (l_2 - l_1) / (k_l * (1.0 + 0.015 * n / Math.Sqrt(20.0 + n)));
	// These coefficients adjust the impact of different harmonic
	// components on the hue difference calculation.
	double t = 1.0	+ 0.24 * Math.Sin(2.0 * h_m + Math.PI * 0.5)
			+ 0.32 * Math.Sin(3.0 * h_m + 8.0 * Math.PI / 15.0)
			- 0.17 * Math.Sin(h_m + Math.PI / 3.0)
			- 0.20 * Math.Sin(4.0 * h_m + 3.0 * Math.PI / 20.0);
	n = c_1 + c_2;
	// Hue.
	double h = 2.0 * Math.Sqrt(c_1 * c_2) * Math.Sin(h_d) / (k_h * (1.0 + 0.0075 * n * t));
	// Chroma.
	double c = (c_2 - c_1) / (k_c * (1.0 + 0.0225 * n));
	// Returning the square root ensures that the result reflects the actual geometric
	// distance within the color space, which ranges from 0 to approximately 185.
	return Math.Sqrt(l * l + h * h + c * c + c * h * r_t);
}
