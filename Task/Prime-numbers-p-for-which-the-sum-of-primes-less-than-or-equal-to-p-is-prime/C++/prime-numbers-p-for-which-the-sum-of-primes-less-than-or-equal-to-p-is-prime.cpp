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
	uint32_t sum = 0;
	for ( uint32_t i = 2; i < 1'000; ++i ) {
		if ( is_prime(i) ) {
			sum += i;
			if ( is_prime(sum) ) {
				std::cout << i << " ";
			}
		}
	}
	std::cout << std::endl;
}
