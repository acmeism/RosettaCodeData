#include <cstdint>
#include <iostream>

bool is_palindromic_in_base(uint32_t n, const uint32_t& base) {
	uint32_t n_copy = n;
	uint32_t value = 0;
	while ( n > 0 ) {
		value = value * base + n % base;
		n /= base;
	}
	return n_copy == value;
}

int main() {
	for ( uint32_t n = 0; n < 25'000; ++n ) {
		if ( is_palindromic_in_base(n, 2) && is_palindromic_in_base(n, 4) && is_palindromic_in_base(n, 16) ) {
			std::cout << n << " ";
		}
	}
	std::cout << std::endl;
}
