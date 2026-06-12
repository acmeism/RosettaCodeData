#include <cstdint>
#include <iostream>

bool is_prime(uint32_t number) {
	if ( number < 2 || number % 2 == 0 ) {
		return number == 2;
	}

	for ( uint32_t i = 3; i * i <= number; i += 2 ) {
		if ( number % i == 0 ) {
			return false;
		}
	}
	return true;
}

int main() {
	for ( uint32_t n = 5; n < 5500; ++n ) {
		if ( is_prime(n) && is_prime(n + 2) && is_prime(n + 6) ) {
			std::cout << "[" << n << ", " << n + 2 << ", " << n + 6 << "]" << std::endl;
		}
	}
}
