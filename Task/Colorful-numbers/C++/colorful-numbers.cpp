#include <cstdint>
#include <iomanip>
#include <iostream>
#include <vector>

std::vector<uint32_t> count(8, 0);
std::vector<bool> used(10, false);
uint32_t largest = 0;

bool is_colorful(const uint32_t& number) {
	if ( number > 98'765'432 ) {
		return false;
	}

	std::vector<uint32_t> digit_count(10, 0);
	std::vector<uint32_t> digits(8, 0);
	uint32_t number_digits = 0;

	for ( uint32_t i = number; i > 0; i /= 10 ) {
		uint32_t digit = i % 10;
		if ( number > 9 && ( digit == 0 || digit == 1 ) ) {
			return false;
		}
		if ( ++digit_count[digit] > 1 ) {
			return false;
		}
		digits[number_digits++] = digit;
	}

	std::vector<uint32_t> products(36, 0);
	for ( uint32_t i = 0, product_count = 0; i < number_digits; ++i ) {
		for ( uint32_t j = i, product = 1; j < number_digits; ++j ) {
			product *= digits[j];
			for ( uint32_t k = 0; k < product_count; ++k ) {
				if ( products[k] == product ) {
					return false;
				}
			}
			products[product_count++] = product;
		}
	}
	return true;
}

void count_colorful(const uint32_t& taken, const uint32_t& number, const uint32_t& digits) {
	if ( taken == 0 ) {
		for ( uint32_t digit = 0; digit < 10; ++digit ) {
			used[digit] = true;
			count_colorful(digit < 2 ? 9 : 1, digit, 1);
			used[digit] = false;
		}
	} else {
		if ( is_colorful(number) ) {
			++count[digits - 1];
			if ( number > largest ) {
				largest = number;
			}
		}
		if ( taken < 9 ) {
			for ( uint32_t digit = 2; digit < 10; ++digit ) {
				if ( ! used[digit] ) {
					used[digit] = true;
					count_colorful(taken + 1, number * 10 + digit, digits + 1);
					used[digit] = false;
				}
			}
		}
	}
}

int main() {
	std::cout << "Colorful numbers less than 100:" << std::endl;
	for ( uint32_t number = 0, count = 0; number < 100; ++number ) {
		if ( is_colorful(number) ) {
			std::cout << std::setw(2) << number << ( ++count % 10 == 0 ? "\n" : " ");
		}
	}
	std::cout << "\n" << std::endl;

	count_colorful(0, 0, 0);
	std::cout << "Count of colorful numbers by number of digits:" << std::endl;
	uint32_t total = 0;
	for ( uint32_t digit = 0; digit < 8; ++digit ) {
		std::cout << digit + 1 << ": " << count[digit] << std::endl;
		total += count[digit];
	}
	std::cout << std::endl;

	std::cout << "The largest possible colorful number is: " << largest << "\n" << std::endl;
	std::cout << "The total number of colorful numbers is: " << total << std::endl;
}
