use std::f64::consts::PI;

// The classic CIE ΔE2000 implementation, which operates on two L*a*b* colors, and returns their difference.
fn ciede_2000(l_1: f64, a_1: f64, b_1: f64, l_2: f64, a_2: f64, b_2: f64) -> f64 {
	// Michel Leonard uses Rust with the CIEDE2000 color-difference formula.
	// K_L, K_C, K_H are parametric factors to be adjusted according to
	// different viewing parameters such as textures, backgrounds...
	const K_L: f64 = 1.0;
	const K_C: f64 = 1.0;
	const K_H: f64 = 1.0;
	let mut n = (a_1.hypot(b_1) + a_2.hypot(b_2)) * 0.5;
	n = n * n * n * n * n * n * n;
	// GitHub Project :
	// https://github.com/michel-leonard/ciede2000-color-matching
	n = 1.0 + 0.5 * (1.0 - (n / (n + 6103515625.0)).sqrt());
	// hypot calculates the Euclidean distance while avoiding overflow/underflow.
	let c_1: f64 = (a_1 * n).hypot(b_1);
	let c_2: f64 = (a_2 * n).hypot(b_2);
	// atan2 is preferred over atan because it accurately computes the angle of
	// a point (x, y) in all quadrants, handling the signs of both coordinates.
	let mut h_1 = b_1.atan2(a_1 * n);
	let mut h_2 = b_2.atan2(a_2 * n);
	if h_1 < 0.0 { h_1 += 2.0 * PI; }
	if h_2 < 0.0 { h_2 += 2.0 * PI; }
	n = (h_2 - h_1).abs();
	// Cross-implementation consistent rounding.
	 if (PI - 1e-14..=PI + 1e-14).contains(&n) { n = PI; }
	// When the hue angles lie in different quadrants, the straightforward
	// average can produce a mean that incorrectly suggests a hue angle in
	// the wrong quadrant, the next lines handle this issue.
	let mut h_m = (h_1 + h_2) * 0.5;
	let mut h_d = (h_2 - h_1) * 0.5;
	if PI < n {
		if 0.0 < h_d { h_d -= PI; } else { h_d += PI; }
		// Some implementations delete the next line and uncomment the one after it,
		// this can lead to a discrepancy of ±0.0003 in the final color difference.
		h_m += PI;
		// if h_m < PI { h_m += PI; } else { h_m -= PI; }
	}
	let p = 36.0 * h_m - 55.0 * PI;
	n = (c_1 + c_2) * 0.5;
	n = n * n * n * n * n * n * n;
	// The hue rotation correction term is designed to account for the
	// non-linear behavior of hue differences in the blue region.
	let r_t = -2.0 * (n / (n + 6103515625.0)).sqrt() * (PI / 3.0 * (p * p / (-25.0 * PI * PI)).exp()).sin();
	n = (l_1 + l_2) * 0.5;
	n = (n - 50.0) * (n - 50.0);
	// Lightness.
	let l = (l_2 - l_1) / (K_L * (1.0 + 0.015 * n / (20.0 + n).sqrt()));
	// These coefficients adjust the impact of different harmonic
	// components on the hue difference calculation.
	let t = 1.0 	+ 0.24 * (2.0 * h_m + PI * 0.5).sin()
			+ 0.32 * (3.0 * h_m + 8.0 * PI / 15.0).sin()
			- 0.17 * (h_m + PI / 3.0).sin()
			- 0.20 * (4.0 * h_m + 3.0 * PI / 20.0).sin();
	n = c_1 + c_2;
	// Hue.
	let h = 2.0 * (c_1 * c_2).sqrt() * (h_d).sin() / (K_H * (1.0 + 0.0075 * n * t));
	// Chroma.
	let c = (c_2 - c_1) / (K_C * (1.0 + 0.0225 * n));
	// Returning the square root ensures that the result represents
	// the "true" geometric distance in the color space.
	(l * l + h * h + c * c + c * h * r_t).sqrt()
}
