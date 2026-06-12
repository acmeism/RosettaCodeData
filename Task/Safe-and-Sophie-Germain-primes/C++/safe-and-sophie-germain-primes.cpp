#include <cstdint>
#include <iomanip>
#include <iostream>

bool is_prime(const uint32_t& number) {
	if ( number < 2 || ( number & 1 ) == 0 ) {
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
	std::cout << "The first 50 Sophie Germain primes:" << std::endl;
	uint32_t number = 1;
	for ( uint32_t count = 0; count < 50; ++count ) {
		do {
			number++;
		} while ( ! ( is_prime(number) && is_prime(2 * number + 1) ) );

		std::cout << std::setw(4) << number << ( count % 10 == 9 ? "\n" : " " );
	}
	std::cout << std::endl;
}
