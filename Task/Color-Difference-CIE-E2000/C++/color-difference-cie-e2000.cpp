#include <cmath>

// The classic CIE ΔE2000 implementation, which operates on two L*a*b* colors, and returns their difference.
// "l" ranges from 0 to 100, while "a" and "b" are unbounded and commonly clamped to the range of -128 to 127.
template <typename T>
static T ciede_2000(const T l_1, const T a_1, const T b_1, const T l_2, const T a_2, const T b_2) {
	// Michel Leonard uses C++ with the CIEDE2000 color-difference formula.
	// k_l, k_c, k_h are parametric factors to be adjusted according to
	// different viewing parameters such as textures, backgrounds...
	const T k_l = T(1.0);
	const T k_c = T(1.0);
	const T k_h = T(1.0);
	T n = (std::hypot(a_1, b_1) + std::hypot(a_2, b_2)) * T(0.5);
	n = n * n * n * n * n * n * n;
	// A factor involving chroma raised to the power of 7 designed to make
	// the influence of chroma on the total color difference more accurate.
	n = T(1.0) + T(0.5) * (T(1.0) - std::sqrt(n / (n + T(6103515625.0))));
	// hypot calculates the Euclidean distance while avoiding overflow/underflow.
	const T c_1 = std::hypot(a_1 * n, b_1);
	const T c_2 = std::hypot(a_2 * n, b_2);
	// atan2 is preferred over atan because it accurately computes the angle of
	// a point (x, y) in all quadrants, handling the signs of both coordinates.
	T h_1 = std::atan2(b_1, a_1 * n);
	T h_2 = std::atan2(b_2, a_2 * n);
	// Github project: https://github.com/michel-leonard/ciede2000-color-matching
	if (h_1 < T(0.0))
		h_1 += T(2.0) * T(M_PI);
	if (h_2 < T(0.0))
		h_2 += T(2.0) * T(M_PI);
	n = std::fabs(h_2 - h_1);
	// Cross-implementation consistent rounding.
	if (T(M_PI) - T(1E-14) < n && n < T(M_PI) + T(1E-14))
		n = T(M_PI);
	// When the hue angles lie in different quadrants, the straightforward
	// average can produce a mean that incorrectly suggests a hue angle in
	// the wrong quadrant, the next lines handle this issue.
	T h_m = (h_1 + h_2) * T(0.5);
	T h_d = (h_2 - h_1) * T(0.5);
	h_d += (T(M_PI) < n) * ((T(0.0) < h_d) - (h_d <= T(0.0))) * T(M_PI);
	// Some implementations delete the next line and uncomment the one after it,
	// this can lead to a discrepancy of ±0.0003 in the final color difference.
	h_m += (T(M_PI) < n) * T(M_PI);
	// h_m += (T(M_PI) < n) * ((h_m < T(M_PI)) - (T(M_PI) <= h_m)) * T(M_PI);
	const T p = T(36.0) * h_m - T(55.0) * T(M_PI);
	n = (c_1 + c_2) * T(0.5);
	n = n * n * n * n * n * n * n;
	// The hue rotation correction term is designed to account for the
	// non-linear behavior of hue differences in the blue region.
	const T r_t = T(-2.0) * std::sqrt(n / (n + T(6103515625.0)))
				  * std::sin(T(M_PI) / T(3.0) * std::exp(p * p / (T(-25.0) * T(M_PI) * T(M_PI))));
	n = (l_1 + l_2) * T(0.5);
	n = (n - T(50.0)) * (n - T(50.0));
	// Lightness.
	const T l = (l_2 - l_1) / (k_l * (T(1.0) + T(0.015) * n / std::sqrt(T(20.0) + n)));
	// These coefficients adjust the impact of different harmonic
	// components on the hue difference calculation.
	const T t = T(1.0)  + T(0.24) * std::sin(T(2.0) * h_m + T(M_PI) / T(2.0))
				+ T(0.32) * std::sin(T(3.0) * h_m + T(8.0) * T(M_PI) / T(15.0))
				- T(0.17) * std::sin(h_m + T(M_PI) / T(3.0))
				- T(0.20) * std::sin(T(4.0) * h_m + T(3.0) * T(M_PI) / T(20.0));
	n = c_1 + c_2;
	// Hue.
	const T h = T(2.0) * std::sqrt(c_1 * c_2) * std::sin(h_d) / (k_h * (T(1.0) + T(0.0075) * n * t));
	// Chroma.
	const T c = (c_2 - c_1) / (k_c * (T(1.0) + T(0.0225) * n));
	// Returning the square root ensures that the result reflects the actual geometric
	// distance within the color space, which ranges from 0 to approximately 185.
	return std::sqrt(l * l + h * h + c * c + c * h * r_t);
}

#include <iomanip>
#include <iostream>
#include <vector>

int main() {
	const std::vector<std::vector<double>> tests = {
			{ 73.0,   49.0,   39.4, 73.0,   49.0,   39.4 },
			{ 30.0,  -41.0, -119.1, 30.0,  -41.0, -119.0 },
			{ 79.0, -117.0, -100.4, 79.5, -117.0, -100.0 },
			{ 15.0,  -55.0,    6.7, 14.0,  -55.0,    7.0 },
			{ 83.0,   98.0,  -59.5, 85.2,   98.0,  -59.5 },
			{ 59.0,  -11.0,  -95.0, 56.3,  -11.0,  -95.0 },
			{ 74.0,   -1.0,   68.6, 81.0,   -1.0,   69.0 },
			{ 46.4,  125.0,    6.0, 40.0,  125.0,    6.0 },
			{ 18.0,   -5.0,   68.0, 20.0,    5.0,   82.0 },
			{ 35.5,  -99.0,  109.0, 25.0,  -99.0,  109.0 },
			{ 59.0,   77.0,   41.5, 63.3,   77.0,   12.4 },
			{ 40.0,  -92.0,    7.7, 58.0,  -92.0,   -8.0 },
			{ 49.0,   -9.0,  -74.5, 51.1,   31.0,   16.0 },
			{ 88.0, -124.0,   56.0, 97.0,   62.0,  -28.0 },
			{ 98.0,   75.7,   11.0,  3.0,  -62.0,   11.0 }
	};

	std::cout << "   L1 	    a1 	    b1     L2     a2 	  b2       ΔE2000" << std::endl;
	std::cout << "------------------------------------------------------------" << std::endl;
	for ( const std::vector<double>& test : tests ) {
		std::cout << std::fixed << std::setprecision(1) << std::setw(6) << test[0] << std::setw(9) << test[1]
				  << std::setw(8) << test[2] << std::setw(7) << test[3] << std::setw(7) << test[4] << std::setw(8) << test[5]
				  << std::setw(15) << std::setprecision(10)
				  << ciede_2000(test[0], test[1], test[2], test[3], test[4], test[5]) << std::endl;
	}
}
