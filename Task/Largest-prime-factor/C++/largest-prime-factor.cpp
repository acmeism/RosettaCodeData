#include <cstdint>
#include <iostream>
#include <stdexcept>
#include <vector>

uint64_t largest_prime_factor(uint64_t number) {
	if ( number < 2 ) {
		throw std::invalid_argument("Argument must be >= 2");
	}

	const std::vector<uint32_t> increments = { 4, 2, 4, 2, 4, 6, 2, 6 };
	uint64_t largest = 1;
	for ( const uint32_t divisor : { 2, 3, 5 } ) {
		while ( number % divisor == 0 ) {
			largest = divisor;
			number /= divisor;
		}
	}

	uint64_t k = 7;
	uint32_t i = 0;
	while ( k * k <= number ) {
		if ( number % k == 0 ) {
			largest = k;
			number /= k;
		} else {
			k += increments[i];
			i = ( i + 1 ) % 8;
		}
	}
	return ( number > 1 ) ? number : largest;
}

int main() {
	std::cout << "The largest prime factor of 600851475143 is " << largest_prime_factor(600851475143) << std::endl;
}
