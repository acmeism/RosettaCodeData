#include <algorithm>
#include <cmath>
#include <cstdint>
#include <iostream>
#include <vector>

std::vector<uint32_t> find_digits(uint64_t number) {
	std::vector<uint32_t> result;
	while ( number != 0 ) {
		result.emplace(result.begin(), number % 10);
		number /= 10;
	}
	return result;
}

uint64_t find_sub_unit(const std::vector<uint32_t>& digits) {
	uint64_t result = 0;
	for ( const uint32_t& digit : digits ) {
		result = 10 * result + ( digit - 1 );
	}
	return result;
}

bool is_square(const uint64_t& number) {
	const uint64_t squareRoot = std::sqrt(number);
	return number == squareRoot * squareRoot;
}

bool contains(const std::vector<uint32_t>& digits, uint32_t digit) {
	return std::find(digits.begin(), digits.end(), digit) != digits.end();
}

int main() {
	const uint32_t sub_units_required = 7;
	std::cout << "The first " << sub_units_required << " sub-unit squares are:" << std::endl;
	std::cout << 1 << std::endl;
	uint64_t number = 2;
	uint32_t count = 1;
	while ( count < sub_units_required ) {
		const uint64_t square = number * number;
		std::vector<uint32_t> digits = find_digits(square);
		if ( ! contains(digits, 0) && digits[0] != 1 ) {
			const uint64_t sub_unit = find_sub_unit(digits);
			if ( is_square(sub_unit) ) {
				std::cout << square << std::endl;
				count++;
			}
		}
		number++;
	}
}
