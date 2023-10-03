#include <cmath>
#include <cstdint>
#include <iomanip>
#include <iostream>

uint64_t power_modulus(uint64_t base, uint64_t exponent, const uint64_t& modulus) {
	if ( modulus == 1 ) {
		return 0;
	}

	base %= modulus;
	uint64_t result = 1;
	while ( exponent > 0 ) {
		if ( ( exponent & 1 ) == 1 ) {
			result = ( result * base ) % modulus;
		}
		base = ( base * base ) % modulus;
		exponent >>= 1;
	}
	return result;
}

bool is_deceptive(const uint32_t& n) {
	if ( n % 2 != 0 && n % 3 != 0 && n % 5 != 0 && power_modulus(10, n - 1, n) == 1 ) {
		for ( uint32_t divisor = 7; divisor < sqrt(n); divisor += 6 ) {
			if ( n % divisor == 0 || n % ( divisor + 4 ) == 0 ) {
				return true;
			}
		}
	}
	return false;
}

int main() {
	uint32_t n = 7;
	uint32_t count = 0;
	while ( count < 100 ) {
		if ( is_deceptive(n) ) {
			std::cout << std::setw(6) << n << ( ++count % 10 == 0 ? "\n" : " " );
		}
		n += 1;
	}
}
