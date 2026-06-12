#include <math.h>
#include <stdio.h>

// Expressly defining pi ensures that the code works on different platforms.
#ifndef M_PI
#define M_PI 3.14159265358979323846264338328
#endif

// The classic CIE ΔE2000 implementation, which operates on two L*a*b* colors, and returns their difference.
static double ciede_2000(const double l_1, const double a_1, const double b_1, const double l_2, const double a_2, const double b_2) {
	// Michel Leonard uses C with the CIEDE2000 color-difference formula.
	// k_l, k_c, k_h are parametric factors to be adjusted according to
	// different viewing parameters such as textures, backgrounds...
	const double k_l = 1.0, k_c = 1.0, k_h = 1.0;
	double n = (hypot(a_1, b_1) + hypot(a_2, b_2)) * 0.5;
	n = n * n * n * n * n * n * n;
	// GitHub Project :
	// https://github.com/michel-leonard/ciede2000-color-matching
	n = 1.0 + 0.5 * (1.0 - sqrt(n / (n + 6103515625.0)));
	// hypot calculates the Euclidean distance while avoiding overflow/underflow.
	const double c_1 = hypot(a_1 * n, b_1), c_2 = hypot(a_2 * n, b_2);
	// atan2 is preferred over atan because it accurately computes the angle of
	// a point (x, y) in all quadrants, handling the signs of both coordinates.
	double h_1 = atan2(b_1, a_1 * n), h_2 = atan2(b_2, a_2 * n);
	h_1 += 2.0 * M_PI * (h_1 < 0.0);
	h_2 += 2.0 * M_PI * (h_2 < 0.0);
	n = fabs(h_2 - h_1);
	// Cross-implementation consistent rounding.
	if (M_PI - 1E-14 < n && n < M_PI + 1E-14)
		n = M_PI;
	// When the hue angles lie in different quadrants, the straightforward
	// average can produce a mean that incorrectly suggests a hue angle in
	// the wrong quadrant, the next lines handle this issue.
	double h_m = (h_1 + h_2) * 0.5;
	double h_d = (h_2 - h_1) * 0.5;
	h_d += (M_PI < n) * ((0.0 < h_d) - (h_d <= 0.0)) * M_PI;
	// Some implementations delete the next line and uncomment the one after it,
	// this can lead to a discrepancy of ±0.0003 in the final color difference.
	h_m += (M_PI < n) * M_PI;
	// h_m += (M_PI < n) * ((h_m < M_PI) - (M_PI <= h_m)) * M_PI;
	const double p = 36.0 * h_m - 55.0 * M_PI;
	n = (c_1 + c_2) * 0.5;
	n = n * n * n * n * n * n * n;
	// The hue rotation correction term is designed to account for the
	// non-linear behavior of hue differences in the blue region.
	const double r_t = -2.0 * sqrt(n / (n + 6103515625.0))
				* sin(M_PI / 3.0 * exp(p * p / (-25.0 * M_PI * M_PI)));
	n = (l_1 + l_2) * 0.5;
	n = (n - 50.0) * (n - 50.0);
	// Lightness.
	const double l = (l_2 - l_1) / (k_l * (1.0 + 0.015 * n / sqrt(20.0 + n)));
	// These coefficients adjust the impact of different harmonic
	// components on the hue difference calculation.
	const double t = 1.0 	+ 0.24 * sin(2.0 * h_m + M_PI * 0.5)
				+ 0.32 * sin(3.0 * h_m + 8.0 * M_PI / 15.0)
				- 0.17 * sin(h_m + M_PI / 3.0)
				- 0.20 * sin(4.0 * h_m + 3.0 * M_PI / 20.0);
	n = c_1 + c_2;
	// Hue.
	const double h = 2.0 * sqrt(c_1 * c_2) * sin(h_d) / (k_h * (1.0 + 0.0075 * n * t));
	// Chroma.
	const double c = (c_2 - c_1) / (k_c * (1.0 + 0.0225 * n));
	// Returning the square root ensures that the result represents
	// the "true" geometric distance in the color space.
	return sqrt(l * l + h * h + c * c + c * h * r_t);
}

int main() {
    const double t[15][6] = {
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
    printf("   L1 	    a1 	    b1     L2     a2 	  b2       ΔE2000\n");
    printf("------------------------------------------------------------\n");
    const char *f = "%6.1f   %6.1f  %6.1f %6.1f %6.1f  %6.1f %14.10f\n";
    for (int i = 0; i < 15; ++i) {
        double res = ciede_2000(t[i][0], t[i][1], t[i][2], t[i][3], t[i][4], t[i][5]);
        printf(f, t[i][0], t[i][1], t[i][2], t[i][3], t[i][4], t[i][5], res);
    }
    return 0;
}

// Compilation is done using GCC or CLang :
// - gcc -std=c99 -Wall -Wextra -pedantic -Ofast -o ciede-2000-compiled ciede-2000.c -lm
// - clang -std=c99 -Wall -Wextra -pedantic -Ofast -o ciede-2000-compiled ciede-2000.c -lm
