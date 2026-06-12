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
	uint64_t sum = 2;
	for ( uint32_t i = 3; i < 2'000'000; i += 2 ) {
		if ( is_prime(i) ) {
			sum += i;
		}
	}
	std::cout << sum << std::endl;
}
