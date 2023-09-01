package golden
import "core:fmt"
import "core:math"
/* main block */
main :: proc() {
	iterate()
}
/* definitions */
iterate :: proc() {
	count := 0
	phi0: f64 = 1.0
	difference: f64 = 1.0
	phi1: f64
	fmt.println("\nGolden ratio/Convergence")
	fmt.println("-----------------------------------------")
	for 1.0e-5 < difference {
		phi1 = 1.0 + (1.0 / phi0)
		difference = abs(phi1 - phi0)
		phi0 = phi1
		count += 1
		fmt.printf("Iteration %2d : Estimate : %.8f\n", count, phi1)
	}
	fmt.println("-----------------------------------------")
	fmt.printf("Result: %.8f after %d iterations", phi1, count)
	fmt.printf("\nThe error is approximately %.10f\n", (phi1 - (0.5 * (1.0 + math.sqrt_f64(5.0)))))
}
