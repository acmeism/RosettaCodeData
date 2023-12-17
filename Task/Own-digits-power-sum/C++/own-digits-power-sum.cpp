#include <cmath>
#include <cstdint>
#include <iostream>
#include <vector>

int main() {
	std::vector<uint32_t> powers = { 0, 1, 4, 9, 16, 25, 36, 49, 64, 81 };

	std::cout << "Own digits power sums for N = 3 to 9 inclusive:" << std::endl;

	for ( uint32_t n = 3; n <= 9; ++n ) {
		for ( uint32_t d = 2; d <= 9; ++d ) {
			powers[d] *= d;
		}

		uint64_t number = std::pow(10, n - 1);
		uint64_t maximum = number * 10;
		uint32_t last_digit = 0;
		uint32_t digit_sum = 0;

		while ( number < maximum ) {
			if ( last_digit == 0 ) {
				digit_sum = 0;
				uint64_t copy = number;
				while ( copy > 0 ) {
					digit_sum += powers[copy % 10];
					copy /= 10;
				}
			} else if ( last_digit == 1 ) {
				digit_sum++;
			} else {
				digit_sum += powers[last_digit] - powers[last_digit - 1];
			}

			if ( digit_sum == number ) {
				std::cout << number << std::endl;
				if ( last_digit == 0 ) {
					std::cout << number + 1 << std::endl;
				}
				number += 10 - last_digit;
				last_digit = 0;
			} else if ( digit_sum > number ) {
				number += 10 - last_digit;
				last_digit = 0;
			} else if ( last_digit < 9 ) {
				number++;
				last_digit++;
			} else {
				number++;
				last_digit = 0;
			}
		}
	}
}
