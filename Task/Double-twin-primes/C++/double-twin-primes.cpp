#include <cstdint>
#include <iostream>

bool is_prime(const uint32_t& number) {
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
	std::cout << "Double twin primes under 1,000:" << std::endl;
	for ( uint32_t n = 3; n <= 991; n += 2 ) {
		if ( is_prime(n) && is_prime(n + 2) && is_prime(n + 6) && is_prime(n + 8) ) {
			std::cout << "[" << n << ", " << n + 2 << ", " << n + 6 << ", " << n + 8 << "]" << std::endl;
		}
	}
}
