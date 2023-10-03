#include <cmath>
#include <cstdint>
#include <iostream>
#include <numeric>
#include <random>

uint64_t test_value = 0;
uint64_t sqrt_test_value = 0;

class BQF { // Binary quadratic form
public:
	BQF(const uint64_t& a, const uint64_t& b, const uint64_t& c) : a(a), b(b), c(c) {
		q = ( sqrt_test_value + b ) / c;
		bb = q * c - b;
	}

	BQF rho() {
		return BQF(c, bb, a  + q * ( b - bb ));
	}

	BQF rho_inverse() {
		return BQF(c, bb, ( test_value - bb * bb ) / c);
	}

	uint64_t a, b, c;
private:
	uint64_t q, bb;
};

uint64_t squfof(const uint64_t& number) {
	const uint32_t sqrt = std::sqrt(number);
	if ( sqrt * sqrt == number ) {
		return sqrt;
	}

	test_value = number;
	sqrt_test_value = std::sqrt(test_value);

	// Principal form
	BQF form(0, sqrt_test_value, 1);
	form = form.rho_inverse();

	// Search principal cycle
	for ( uint32_t i = 0; i < 4 * std::sqrt(2 * sqrt_test_value); i += 2 ) {
		// Even step
		form = form.rho();

		uint64_t sqrt_c = std::sqrt(form.c);
		if ( sqrt_c * sqrt_c == form.c ) { // Square form found
			// Inverse square root
			BQF form_inverse(0, -form.b, sqrt_c);
			form_inverse = form_inverse.rho_inverse();

			// Search ambiguous cycle
			uint64_t previous_b = 0;
			do {
				previous_b = form_inverse.b;
				form_inverse = form_inverse.rho();
			} while ( form_inverse.b != previous_b );

			// Symmetry point
			const uint64_t g = std::gcd(number, form_inverse.a);
			if ( g != 1 ) {
				return g;
			}
		}

		// Odd step
		form = form.rho();
	}

	if ( number % 2 == 0 ) {
		return 2;
	}
	return 0; // Failed to factorise, possibly a prime number
}

int main() {
	std::random_device random;
	std::mt19937 generator(random());
	const uint64_t lower_limit = 100'000'000'000'000'000;
	std::uniform_int_distribution<uint64_t> distribution(lower_limit, 10 * lower_limit);

	for ( uint32_t i = 0; i < 20; ++i ) {
		uint64_t test = distribution(random);
		uint64_t factor = squfof(test);

		if ( factor == 0 ) {
			std::cout << test << " - failed to factorise" << std::endl;
		} else {
			std::cout << test << " = " << factor << " * " << test / factor << std::endl;
		}
		std::cout << std::endl;
   }
}
