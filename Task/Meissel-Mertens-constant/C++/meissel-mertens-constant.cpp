#include <cmath>
#include <cstdint>
#include <iomanip>
#include <iostream>
#include <vector>

std::vector<double> list_prime_reciprocals(const int32_t& limit) {
	const int32_t half_limit = ( limit % 2 == 0 ) ? limit / 2 : 1 + limit / 2;
	std::vector<bool> composite(half_limit);
	for ( int32_t i = 1, p = 3; i < half_limit; p += 2, ++i ) {
		if ( ! composite[i] ) {
			for ( int32_t a = i + p; a < half_limit; a = a + p ) {
				composite[a] = true;
			}
		}
	}

	std::vector<double> result(composite.size());
	result[0] = 0.5;
	for ( int32_t i = 1, p = 3; i < half_limit; p += 2, ++i ) {
		if ( ! composite[i] ) {
			result.emplace_back(1.0 / p);
		}
	}
	return result;
}

int main() {
	std::vector<double> prime_reciprocals = list_prime_reciprocals(100000000);
	const double euler = 0.577215664901532861;
	double sum = 0.0;
	for ( double reciprocal : prime_reciprocals ) {
		sum += reciprocal + log(1.0 - reciprocal);
	}

	const double meissel_mertens = euler + sum;
	std::cout << "The Meissel-Mertens constant = " << std::setprecision(8) << meissel_mertens << std::endl;
}
