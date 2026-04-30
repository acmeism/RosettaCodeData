(
var ans;
// Usage: ~golden_ratio.(r), where r is a positive
// floating point number serving as a stop condition.
//
// Return an array in the form [phi, n, err], where:
//  - phi is the computed value for the golden ratio
//  - n is the number of iterations used to compute phi
//  - err is the distance between phi and the true value of
//    the golden ratio
~golden_ratio = {
	arg r; var phi1 = 1, phi2 = 2, n = 1;

	while{abs(phi2 - phi1) > r}{
		phi1 = phi2; phi2 = 1 + (1/phi2); n = n + 1;
	};

	[phi2, n, abs( ((1 + sqrt(5))/2) - phi2 )];
};

ans = ~golden_ratio.(1e-5);
("computed value for 𝛟: " ++ ans[0]).postln;
("number of iterations: " ++ ans[1]).postln;
("error with respect to the exact value: " ++ ans[2]).postln;
)
