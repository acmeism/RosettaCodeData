#include <algorithm>
#include <cstdint>
#include <iostream>

// Convert the given decimal number to the given number base
// and return it converted to a string
std::string to_base_string(const uint64_t& number, const uint32_t& base) {
	uint64_t n = number;
	if ( n == 0 ) {
		return "0";
	}

	std::string result;
	while ( n > 0 ) {
		result += std::to_string(n % base);
		n /= base;
	}
	std::reverse(result.begin(), result.end());
	return result;
}

void display(const uint64_t& number) {
	std::cout << "Decimal: " << number << std::endl;
	std::cout << "Binary : " << to_base_string(number, 2) << std::endl;
	std::cout << "Ternary: " << to_base_string(number, 3) << std::endl << std::endl;
}

bool is_palindromic(const std::string& number) {
	std::string copy = number;
	std::reverse(copy.begin(), copy.end());
	return number == copy;
}

// Create a ternary palindrome whose left part is the ternary equivalent of the given number
// and return it converted to a decimal
uint64_t create_ternary_palindrome(const uint64_t& number) {
	std::string ternary = to_base_string(number, 3);
	uint64_t power_of_3 = 1;
	uint64_t result = 0;
	for ( uint64_t i = 0; i < ternary.length(); ++i ) { // Right part of palindrome is the mirror image of left part
		if ( ternary[i] > '0' ) {
			result += ( ternary[i] - '0' ) * power_of_3;
		}
		power_of_3 *= 3;
	}
	result += power_of_3; // Middle digit must be 1
	power_of_3 *= 3;
	result += number * power_of_3; // Left part is the given number multiplied by the appropriate power of 3
	return result;
}

int main() {
	std::cout << "The first 6 numbers which are palindromic in both binary and ternary are:" << std::endl;
	display(0); // 0 is a palindrome in all 3 bases
	display(1); // 1 is a palindrome in all 3 bases

	uint64_t number = 1;
	uint32_t count = 2;
	do {
		uint64_t ternary = create_ternary_palindrome(number);
		if ( ternary % 2 == 1 )  { // Cannot be an even number since its binary equivalent would end in zero
			std::string binary = to_base_string(ternary, 2);
			if ( binary.length() % 2 == 1 ) { // Binary palindrome must have an odd number of digits
				if ( is_palindromic(binary) ) {
					display(ternary);
					count++;
				}
			}
		}
		number++;
	}
	while ( count < 6 );
}
