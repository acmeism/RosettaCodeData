#include <cstdint>
#include <iostream>

bool is_prime(const int32_t& number) {
	if ( number < 2 || ( number & 1 ) == 0 ) {
		return number == 2;
	}

	for ( int32_t i = 3; i * i <= number; i += 2 ) {
		if ( number % i == 0 ) {
			return false;
		}
	}
	return true;
}

int32_t digit_sum(int32_t number) {
	int32_t sum = 0;
	while ( number > 0 ) {
		sum += number % 10;
		number /= 10;
	}
	return sum;
}

int main() {
	for ( uint32_t n = 1; n < 100; ++n ) {
		if ( is_prime(digit_sum(n * n)) && is_prime(digit_sum(n * n * n)) ) {
			std::cout << n << " ";
		}
	}
	std::cout << std::endl;
}
