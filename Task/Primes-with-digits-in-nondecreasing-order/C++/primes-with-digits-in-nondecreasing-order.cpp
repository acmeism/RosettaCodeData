#include <cstdint>
#include <iomanip>
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

bool is_non_decreasing(uint32_t n) {
    uint32_t previous = 10;
    while ( n > 0 ) {
    	uint32_t digit = n % 10;
		if ( digit > previous ) {
			return false;
		}
		previous = digit;
		n /= 10;
    }
    return true;
}

int main() {
	for ( uint32_t i = 2; i < 1'000; ++i ) {
		if ( is_prime(i) && is_non_decreasing(i) ) {
			std::cout << i << " ";
		}
	}
	std::cout << std::endl;
}
