ciede_2000_classic <- function(l_1, a_1, b_1, l_2, a_2, b_2) {
	# This scalar expansion wrapper works with numbers, not vectors.
	delta_e <- ciede_2000(c(l_1), c(a_1), c(b_1), c(l_2), c(a_2), c(b_2))
	return(delta_e[1])
}

# The classic vectorized CIE ΔE2000 implementation, which operates on two L*a*b* colors, and returns their difference.
ciede_2000 <- function(l_1, a_1, b_1, l_2, a_2, b_2) {
	# Michel Leonard uses R with the CIEDE2000 color-difference formula.
	# k_l, k_c, k_h are parametric factors to be adjusted according to
	# different viewing parameters such as textures, backgrounds...
	k_l <- 1.0;
	k_c <- 1.0;
	k_h <- 1.0;
	n <- (sqrt(a_1 * a_1 + b_1 * b_1) + sqrt(a_2 * a_2 + b_2 * b_2)) * 0.5;
	n <- n ^ 7;
	# GitHub Project :
	# https://github.com/michel-leonard/ciede2000-color-matching
	n <- 1.0 + 0.5 * (1.0 - sqrt(n / (n + 6103515625.0)));
	# Since hypot is not available, sqrt is used here to calculate the
	# Euclidean distance, without avoiding overflow/underflow.
	c_1 <- sqrt((a_1 * n) ^ 2 + b_1 * b_1);
	c_2 <- sqrt((a_2 * n) ^ 2 + b_2 * b_2);
	# atan2 is preferred over atan because it accurately computes the angle of
	# a point (x, y) in all quadrants, handling the signs of both coordinates.
	h_1 <- atan2(b_1, a_1 * n);
	h_2 <- atan2(b_2, a_2 * n);
	h_1[h_1 < 0] <- h_1[h_1 < 0] + 2.0 * pi;
	h_2[h_2 < 0] <- h_2[h_2 < 0] + 2.0 * pi;
	n <- abs(h_2 - h_1);
	# Cross-implementation consistent rounding.
	n[abs(n - pi) < 1E-14] <- pi;
	# When the hue angles lie in different quadrants, the straightforward
	# average can produce a mean that incorrectly suggests a hue angle in
	# the wrong quadrant, the next lines handle this issue.
	h_m <- (h_1 + h_2) * 0.5;
	h_d <- (h_2 - h_1) * 0.5;
	m_1 <- (pi < n);
	m_2 <- (0.0 < h_d);
	h_d[m_1] <- h_d[m_1] + ifelse(m_2[m_1], -pi, pi);
	h_m[m_1] <- h_m[m_1] + pi;
	p <- 36.0 * h_m - 55.0 * pi;
	n <- (c_1 + c_2) * 0.5;
	n <- n ^ 7;
	# The hue rotation correction term is designed to account for the
	# non-linear behavior of hue differences in the blue region.
	r_t <- -2.0 * sqrt(n / (n + 6103515625.0)) *
			sin(pi / 3.0 * exp(p * p / (-25.0 * pi * pi)));
	n <- (l_1 + l_2) * 0.5;
	n <- (n - 50.0) * (n - 50.0);
	# Lightness.
	l <- (l_2 - l_1) / (k_l * (1.0 + 0.015 * n / sqrt(20.0 + n)));
	# These coefficients adjust the impact of different harmonic
	# components on the hue difference calculation.
	t <- 1.0 +	0.24 * sin(2.0 * h_m + pi * 0.5) +
			0.32 * sin(3.0 * h_m + 8.0 * pi / 15.0) -
			0.17 * sin(h_m + pi / 3.0) -
			0.20 * sin(4.0 * h_m + 3.0 * pi / 20.0);
	n <- c_1 + c_2;
	# Hue.
	h <- 2.0 * sqrt(c_1 * c_2) * sin(h_d) / (k_h * (1.0 + 0.0075 * n * t));
	# Chroma.
	c <- (c_2 - c_1) / (k_c * (1.0 + 0.0225 * n));
	# Returning the square root ensures that the result represents
	# the "true" geometric distance in the color space.
	return(sqrt(l * l + h * h + c * c + c * h * r_t));
}

input_data <- list("l_1"=c(73.0,30.0,79.0,15.0,83.0,59.0,74.0,46.4,18.0,35.5,59.0,40.0,49.0,88.0,98.0),
                   "a_1"=c(49.0,-41.0,-117.0,-55.0,98.0,-11.0,-1.0,125.0,-5.0,-99.0,77.0,-92.0,-9.0,-124.0,75.7),
                   "b_1"=c(39.4,-119.1,-100.4,6.7,-59.5,-95.0,68.6,6.0,68.0,109.0,41.5,7.7,-74.5,56.0,11.0),
                   "l_2"=c(73.0,30.0,79.5,14.0,85.2,56.3,81.0,40.0,20.0,25.0,63.3,58.0,51.1,97.0,3.0),
                   "a_2"=c(49.0,-41.0,-117.0,-55.0,98.0,-11.0,-1.0,125.0,5.0,-99.0,77.0,-92.0,31.0,62.0,-62.0),
                   "b_2"=c(39.4,-119.0,-100.0,7.0,-59.5,-95.0,69.0,6.0,82.0,109.0,12.4,-8.0,16.0,-28.0,11.0))

diffs <- do.call(ciede_2000, input_data)

output_matrix <- cbind(sapply(input_data, `+`), "ΔE2000"=diffs)
print(as.data.frame(output_matrix), row.names=FALSE)
