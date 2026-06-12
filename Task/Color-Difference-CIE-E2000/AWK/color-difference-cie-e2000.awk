# test driver =========================================================================

BEGIN {
    cie_setup();
    standard_test();
}

function standard_test()
{
    printf( "      L1      a1      b1      L2      a2      b2    ΔE2000\n" );
    printf( "----------------------------------------------------------------\n" );
    test( 73.0,   49.0,   39.4, 73.0,   49.0,   39.4 );
    test( 30.0,  -41.0, -119.1, 30.0,  -41.0, -119.0 );
    test( 79.0, -117.0, -100.4, 79.5, -117.0, -100.0 );
    test( 15.0,  -55.0,    6.7, 14.0,  -55.0,    7.0 );
    test( 83.0,   98.0,  -59.5, 85.2,   98.0,  -59.5 );
    test( 59.0,  -11.0,  -95.0, 56.3,  -11.0,  -95.0 );
    test( 74.0,   -1.0,   68.6, 81.0,   -1.0,   69.0 );
    test( 46.4,  125.0,    6.0, 40.0,  125.0,    6.0 );
    test( 18.0,   -5.0,   68.0, 20.0,    5.0,   82.0 );
    test( 35.5,  -99.0,  109.0, 25.0,  -99.0,  109.0 );
    test( 59.0,   77.0,   41.5, 63.3,   77.0,   12.4 );
    test( 40.0,  -92.0,    7.7, 58.0,  -92.0,   -8.0 );
    test( 49.0,   -9.0,  -74.5, 51.1,   31.0,   16.0 );
    test( 88.0, -124.0,   56.0, 97.0,   62.0,  -28.0 );
    test( 98.0,   75.7,   11.0,  3.0,  -62.0,   11.0 );
}

function test( v1, v2, v3, v4, v5, v6 )
{
    printf( " %7.1f %7.1f %7.1f %7.1f %7.1f %7.1f", v1, v2, v3, v4, v5, v6 );
    printf(" %15.10f\n", ciede_2000( v1, v2, v3, v4, v5, v6 ) );
}

# CIE ΔE2000 implementation =============================================================

# call this from your BEGIN block or before the first call to ciede_2000
function cie_setup()
{
	# k_l, k_c, k_h are parametric factors to be adjusted according to
	# different viewing parameters such as textures, backgrounds...
	k_l = k_c = k_h = 1.0
	FS = ","
	M_PI = 3.14159265358979323846264338328
}

# The classic CIE ΔE2000 implementation, which operates on two L*a*b* colors, and returns their difference.
# "l" ranges from 0 to 100, while "a" and "b" are unbounded and commonly clamped to the range of -128 to 127.
function ciede_2000(l_1, a_1, b_1, l_2, a_2, b_2) {
	# Michel Leonard uses AWK with the CIEDE2000 color-difference formula.
	n = (sqrt(a_1 * a_1 + b_1 * b_1) + sqrt(a_2 * a_2 + b_2 * b_2)) * 0.5
	n = n * n * n * n * n * n * n
	# A factor involving chroma raised to the power of 7 designed to make
	# the influence of chroma on the total color difference more accurate.
	n = 1.0 + 0.5 * (1.0 - sqrt(n / (n + 6103515625.0)))
	# Since hypot is not available, sqrt is used here to calculate the
	# Euclidean distance, without avoiding overflow/underflow.
	c_1 = sqrt(a_1 * a_1 * n * n + b_1 * b_1)
	c_2 = sqrt(a_2 * a_2 * n * n + b_2 * b_2)
	# atan2 is preferred over atan because it accurately computes the angle of
	# a point (x, y) in all quadrants, handling the signs of both coordinates.
	h_1 = atan2(b_1, a_1 * n)
	h_2 = atan2(b_2, a_2 * n)
	# GitHub Project : https://github.com/michel-leonard/ciede2000-color-matching
	if (h_1 < 0.0) h_1 += 2.0 * M_PI
	h_2 += 2.0 * M_PI * (h_2 < 0.0)
	n = h_2 < h_1 ? h_1 - h_2 : h_2 - h_1
	# Cross-implementation consistent rounding.
	if (M_PI - 1E-14 < n && n < M_PI + 1E-14)
		n = M_PI
	# When the hue angles lie in different quadrants, the straightforward
	# average can produce a mean that incorrectly suggests a hue angle in
	# the wrong quadrant, the next lines handle this issue.
	h_m = (h_1 + h_2) * 0.5
	h_d = (h_2 - h_1) * 0.5
	if (M_PI < n) {
		if (0.0 < h_d)
			h_d -= M_PI
		else
			h_d += M_PI
		h_m += M_PI
	}
	p = 36.0 * h_m - 55.0 * M_PI
	n = (c_1 + c_2) * 0.5
	n = n * n * n * n * n * n * n
	# The hue rotation correction term is designed to account for the
	# non-linear behavior of hue differences in the blue region.
	r_t = -2.0 * sqrt(n / (n + 6103515625.0)) \
			* sin(M_PI / 3.0 * exp(p * p / (-25.0 * M_PI * M_PI)))
	n = (l_1 + l_2) * 0.5
	n = (n - 50.0) * (n - 50.0)
	# Lightness.
	l = (l_2 - l_1) / (k_l * (1.0 + 0.015 * n / sqrt(20.0 + n)))
	# These coefficients adjust the impact of different harmonic
	# components on the hue difference calculation.
	t = 1.0	+ 0.24 * sin(2.0 * h_m + M_PI * 0.5) \
		+ 0.32 * sin(3.0 * h_m + 8.0 * M_PI / 15.0) \
		- 0.17 * sin(h_m + M_PI / 3.0) \
		- 0.20 * sin(4.0 * h_m + 3.0 * M_PI / 20.0)
	n = c_1 + c_2
	# Hue.
	h = 2.0 * sqrt(c_1 * c_2) * sin(h_d) / (k_h * (1.0 + 0.0075 * n * t))
	# Chroma.
	c = (c_2 - c_1) / (k_c * (1.0 + 0.0225 * n))
	# Returns the square root so that the Delta E 2000 reflects the actual geometric
	# distance within the color space, which ranges from 0 to approximately 185.
	return sqrt(l * l + h * h + c * c + c * h * r_t)
}
