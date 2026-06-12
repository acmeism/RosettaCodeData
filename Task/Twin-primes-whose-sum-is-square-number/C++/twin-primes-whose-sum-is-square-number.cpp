#include <cmath>
#include <cstdint>
#include <iostream>

bool is_prime(uint32_t number) {
	if ( number % 2 == 0 ) {
		return number == 2;
	}
	uint32_t k = 3;
	while ( k * k <= number ) {
		if ( number % k == 0 ) {
			return false;
		}
		k += 2;
	}
	return true;
}

int main() {
	for ( uint32_t n = 3; n < 10'000; n += 2 ) {
		if ( is_prime(n) && is_prime(n + 2) ) {
			const uint32_t sum = 2 * n + 2;
			const uint32_t sqrt = std::sqrt(sum);
			if ( sum == sqrt * sqrt ) {
				std::cout << sqrt << "² = " << n << " + " << n + 2 << std::endl;
			}
		}
	}
}
