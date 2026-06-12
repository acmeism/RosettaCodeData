#include <cstdint>
#include <iomanip>
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

int32_t digit_sum_in_base(int32_t number, const int32_t& base) {
	int32_t sum = 0;
	while ( number > 0 ) {
		sum += number % base;
		number /= base;
	}
	return sum;
}

int main() {
	std::cout << "Numbers less than 200 whose binary and ternary digit sums are prime:" << std::endl;
	int32_t count = 0;
	for ( int32_t i = 2; i < 200; i++ ) {
		if ( is_prime(digit_sum_in_base(i, 2)) && is_prime(digit_sum_in_base(i, 3)) ) {
			count += 1;
			std::cout << std::setw(3) << i << ( count % 20 == 0 ? "\n" : " " );
		}
	}
	std::cout << std::endl;
}
