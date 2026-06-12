from math import pi, sqrt, hypot, atan2, sin, exp


def ciede_2000(l_1, a_1, b_1, l_2, a_2, b_2):
    """
    The classic CIE ΔE2000 implementation, which operates on two L*a*b* colors
    and returns their difference. Michel Leonard uses Python with the CIEDE2000
    color-difference formula. k_l, k_c, k_h are parametric factors to be adjusted
    according to different viewing parameters such as textures, backgrounds...
    """
    k_l = k_c = k_h = 1.0
    n = (hypot(a_1, b_1) + hypot(a_2, b_2)) * 0.5
    n = n * n * n * n * n * n * n
    # GitHub Project :
    # https://github.com/michel-leonard/ciede2000-color-matching
    n = 1.0 + 0.5 * (1.0 - sqrt(n / (n + 6103515625.0)))
    # hypot calculates the Euclidean distance while avoiding overflow/underflow.
    c_1 = hypot(a_1 * n, b_1)
    c_2 = hypot(a_2 * n, b_2)
    # atan2 is preferred over atan because it accurately computes the angle of
    # a point (x, y) in all quadrants, handling the signs of both coordinates.
    h_1 = atan2(b_1, a_1 * n)
    h_2 = atan2(b_2, a_2 * n)
    h_1 += 2.0 * pi * (h_1 < 0.0)
    h_2 += 2.0 * pi * (h_2 < 0.0)
    n = abs(h_2 - h_1)
    # Cross-implementation consistent rounding.
    if pi - 1E-14 < n < pi + 1E-14:
        n = pi
    # When the hue angles lie in different quadrants, the straightforward
    # average can produce a mean that incorrectly suggests a hue angle in
    # the wrong quadrant, the next lines handle this issue.
    h_m = (h_1 + h_2) * 0.5
    h_d = (h_2 - h_1) * 0.5
	if pi < n :
		h_d += pi if h_d < 0.0 else -pi
		# Some implementations delete the next line and uncomment the one after it,
		# this can lead to a discrepancy of ±0.0003 in the final color difference.
		h_m += pi
		# h_m += pi if h_m < pi else -pi
    p = 36.0 * h_m - 55.0 * pi
    n = (c_1 + c_2) * 0.5
    n = n * n * n * n * n * n * n
    # The hue rotation correction term is designed to account for the
    # non-linear behavior of hue differences in the blue region.
    r_t = -2.0 * sqrt(n / (n + 6103515625.0)) \
        * sin(pi / 3.0 * exp(p * p / (-25.0 * pi * pi)))
    n = (l_1 + l_2) * 0.5
    n = (n - 50.0) * (n - 50.0)
    # Lightness.
    l = (l_2 - l_1) / (k_l * (1.0 + 0.015 * n / sqrt(20.0 + n)))
    # These coefficients adjust the impact of different harmonic
    # components on the hue difference calculation.
    t = 1.0 + 0.24 * sin(2.0 * h_m + pi * 0.5) \
            + 0.32 * sin(3.0 * h_m + 8.0 * pi / 15.0) \
        - 0.17 * sin(h_m + pi / 3.0) \
        - 0.20 * sin(4.0 * h_m + 3.0 * pi / 20.0)
    n = c_1 + c_2
    # Hue.
    h = 2.0 * sqrt(c_1 * c_2) * sin(h_d) / (k_h * (1.0 + 0.0075 * n * t))
    # Chroma.
    c = (c_2 - c_1) / (k_c * (1.0 + 0.0225 * n))
    # Returning the square root ensures that the result represents
    # the "true" geometric distance in the color space.
    return sqrt(l * l + h * h + c * c + c * h * r_t)


data = [
    [73.0, 49.0, 39.4, 73.0, 49.0, 39.4],
    [30.0, -41.0, -119.1, 30.0, -41.0, -119.0],
    [79.0, -117.0, -100.4, 79.5, -117.0, -100.0],
    [15.0, -55.0, 6.7, 14.0, -55.0, 7.0],
    [83.0, 98.0, -59.5, 85.2, 98.0, -59.5],
    [59.0, -11.0, -95.0, 56.3, -11.0, -95.0],
    [74.0, -1.0, 68.6, 81.0, -1.0, 69.0],
    [46.4, 125.0, 6.0, 40.0, 125.0, 6.0],
    [18.0, -5.0, 68.0, 20.0, 5.0, 82.0],
    [35.5, -99.0, 109.0, 25.0, -99.0, 109.0],
    [59.0, 77.0, 41.5, 63.3, 77.0, 12.4],
    [40.0, -92.0, 7.7, 58.0, -92.0, -8.0],
    [49.0, -9.0, -74.5, 51.1, 31.0, 16.0],
    [88.0, -124.0, 56.0, 97.0, 62.0, -28.0],
    [98.0, 75.7, 11.0, 3.0, -62.0, 11.0],
]

if __name__ == "__main__":
    print("   L1     a1     b1     L2     a2     b2      ΔE2000")
    print("-----------------------------------------------------------")
    for L1, a1, b1, L2, a2, b2 in data:
        dE = round(ciede_2000(L1, a1, b1, L2, a2, b2), ndigits=12)
        print(f'{L1:6} {a1:6} {b1:6} {L2:6} {a2:6} {b2:6}  {dE}')
