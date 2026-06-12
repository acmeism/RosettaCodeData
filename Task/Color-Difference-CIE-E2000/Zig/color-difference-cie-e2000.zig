const std = @import("std");
const math = std.math;

// The classic CIE ΔE2000 implementation, which operates on two L*a*b* colors, and returns their difference.
// "l" ranges from 0 to 100, while "a" and "b" are unbounded and commonly clamped to the range of -128 to 127.
pub fn ciede_2000(l_1: f64, a_1: f64, b_1: f64, l_2: f64, a_2: f64, b_2: f64) f64 {
    // Michel Leonard uses Zig with the CIEDE2000 color-difference formula.
    // k_l, k_c, k_h are parametric factors to be adjusted according to
    // different viewing parameters such as textures, backgrounds...
    const k_l = 1.0;
    const k_c = 1.0;
    const k_h = 1.0;
    // Expressly defining pi ensures that the code works on different platforms.
    const pi = 3.14159265358979323846264338328;
    var n = (math.hypot(a_1, b_1) + math.hypot(a_2, b_2)) * 0.5;
    n = n * n * n * n * n * n * n;
    // A factor involving chroma raised to the math.power of 7 designed to make
    // the influence of chroma on the total color difference more accurate.
    n = 1.0 + 0.5 * (1.0 - math.sqrt(n / (n + 6103515625.0)));
    // hypot calculates the Euclidean distance while avoiding overflow/underflow.
    const c_1 = math.hypot(a_1 * n, b_1);
    const c_2 = math.hypot(a_2 * n, b_2);
    // atan2 is preferred over atan because it accurately computes the angle of
    // a point (x, y) in all quadrants, handling the signs of both coordinates.
    var h_1 = math.atan2(b_1, a_1 * n);
    var h_2 = math.atan2(b_2, a_2 * n);
    if (h_1 < 0.0) h_1 += 2.0 * pi;
    if (h_2 < 0.0) h_2 += 2.0 * pi;
    // GitHub Project : https://github.com/michel-leonard/ciede2000-color-matching
	if (h_2 < h_1) { n = h_1 - h_2; } else {  n = h_2 - h_1; }
    // Cross-implementation consistent rounding.
    if (pi - 1E-14 < n and n < pi + 1E-14) n = pi;
    // When the hue angles lie in different quadrants, the straightforward
    // average can produce a mean that incorrectly suggests a hue angle in
    // the wrong quadrant, the next lines handle this issue.
    var h_m = (h_1 + h_2) * 0.5;
    var h_d = (h_2 - h_1) * 0.5;
    if (pi < n) {
        if (0.0 < h_d) { h_d -= pi; } else { h_d += pi; }
        h_m += pi;
    }
    const p = 36.0 * h_m - 55.0 * pi;
    n = (c_1 + c_2) * 0.5;
    n = n * n * n * n * n * n * n;
    // The hue rotation correction term is designed to account for the
    // non-linear behavior of hue differences in the blue region.
    const r_t = -2.0 * math.sqrt(n / (n + 6103515625.0))
                        * math.sin(pi / 3.0 * math.exp(p * p / (-25.0 * pi * pi)));
    n = (l_1 + l_2) * 0.5;
    n = (n - 50.0) * (n - 50.0);
    // Lightness.
    const l = (l_2 - l_1) / (k_l * (1.0 + 0.015 * n / math.sqrt(20.0 + n)));
    // These coefficients adjust the impact of different harmonic
    // components on the hue difference calculation.
    const t = 1.0   + 0.24 * math.sin(2.0 * h_m + pi / 2.0)
                    + 0.32 * math.sin(3.0 * h_m + 8.0 * pi / 15.0)
                    - 0.17 * math.sin(h_m + pi / 3.0)
                    - 0.20 * math.sin(4.0 * h_m + 3.0 * pi / 20.0);
    n = c_1 + c_2;
    // Hue.
    const h = 2.0 * math.sqrt(c_1 * c_2) * math.sin(h_d) / (k_h * (1.0 + 0.0075 * n * t));
    // Chroma.
    const c = (c_2 - c_1) / (k_c * (1.0 + 0.0225 * n));
    // Returning the square root ensures that the result reflects the actual geometric
    // distance within the color space, which ranges from 0 to approximately 185.
    return math.sqrt(l * l + h * h + c * c + c * h * r_t);
}

test "Rosetta Calculation Test 1" {
    try std.testing.expectApproxEqAbs(0.0, ciede_2000(73.0, 49.0, 39.4, 73.0, 49.0, 39.4), 0.0000000001);
}
test "Rosetta Calculation Test 2" {
    try std.testing.expectApproxEqAbs(0.0134319631, ciede_2000(30.0, -41.0, -119.1, 30.0, -41.0, -119.0), 0.0000000001);
}
test "Rosetta Calculation Test 3" {
    try std.testing.expectApproxEqAbs(0.3572501235, ciede_2000(79.0, -117.0, -100.4, 79.5, -117.0, -100.0), 0.0000000001);
}
test "Rosetta Calculation Test 4" {
    try std.testing.expectApproxEqAbs(0.6731711696, ciede_2000(15.0, -55.0, 6.7, 14.0, -55.0, 7.0), 0.0000000001);
}
test "Rosetta Calculation Test 5" {
    try std.testing.expectApproxEqAbs(1.4597018301, ciede_2000(83.0, 98.0, -59.5, 85.2, 98.0, -59.5), 0.0000000001);
}
test "Rosetta Calculation Test 6" {
    try std.testing.expectApproxEqAbs(2.4566352112, ciede_2000(59.0, -11.0, -95.0, 56.3, -11.0, -95.0), 0.0000000001);
}
test "Rosetta Calculation Test 7" {
    try std.testing.expectApproxEqAbs(4.9755487499, ciede_2000(74.0, -1.0, 68.6, 81.0, -1.0, 69.0), 0.0000000001);
}
test "Rosetta Calculation Test 8" {
    try std.testing.expectApproxEqAbs(5.8974138376, ciede_2000(46.4, 125.0, 6.0, 40.0, 125.0, 6.0), 0.0000000001);
}
test "Rosetta Calculation Test 9" {
    try std.testing.expectApproxEqAbs(6.8542258013, ciede_2000(18.0, -5.0, 68.0, 20.0, 5.0, 82.0), 0.0000000001);
}
test "Rosetta Calculation Test 10" {
    try std.testing.expectApproxEqAbs(8.1462591143, ciede_2000(35.5, -99.0, 109.0, 25.0, -99.0, 109.0), 0.0000000001);
}
test "Rosetta Calculation Test 11" {
    try std.testing.expectApproxEqAbs(13.1325726695, ciede_2000(59.0, 77.0, 41.5, 63.3, 77.0, 12.4), 0.0000000001);
}
test "Rosetta Calculation Test 12" {
    try std.testing.expectApproxEqAbs(19.1411733022, ciede_2000(40.0, -92.0, 7.7, 58.0, -92.0, -8.0), 0.0000000001);
}
test "Rosetta Calculation Test 13" {
    try std.testing.expectApproxEqAbs(48.1082375109, ciede_2000(49.0, -9.0, -74.5, 51.1, 31.0, 16.0), 0.0000000001);
}
test "Rosetta Calculation Test 14" {
    try std.testing.expectApproxEqAbs(63.9449872676, ciede_2000(88.0, -124.0, 56.0, 97.0, 62.0, -28.0), 0.0000000001);
}
test "Rosetta Calculation Test 15" {
    try std.testing.expectApproxEqAbs(126.5088270078, ciede_2000(98.0, 75.7, 11.0, 3.0, -62.0, 11.0), 0.0000000001);
}
