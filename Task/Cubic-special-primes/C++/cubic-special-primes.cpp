#include <cstdint>
#include <iostream>

bool is_prime(uint32_t number) {
	if ( number % 2 == 0 ) {
		return number == 2;
	}
	int k = 3;
	while ( k * k <= number ) {
		if ( number % k == 0 ) {
			return false;
		}
		k += 2;
	}
	return true;
}

int main() {
	uint32_t p = 2, n = 1;
	std::cout << 2 << " ";

	while ( p + n * n * n < 15'000 ) {
		if ( is_prime(p + n * n * n) ) {
			p += n * n * n;
			n = 1;
			std::cout << p << " ";
		} else {
			n += 1;
		}
	}
}
