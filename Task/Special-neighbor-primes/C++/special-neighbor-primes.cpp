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

uint32_t next_prime(const uint32_t& number) {
	uint32_t result = number;
	do {
		result += 2;
	} while ( ! is_prime(result) );
	return result;
}

int main() {
	for ( uint32_t i = 3; i < 99; i += 2 ) {
		if ( is_prime(i) ) {
			const uint32_t next = next_prime(i);
			if ( next < 100 && is_prime(i + next - 1) ) {
				std::cout << i << " + " << next << " - 1 = " << i + next - 1 << std::endl;
			}
		}
 	}
}
