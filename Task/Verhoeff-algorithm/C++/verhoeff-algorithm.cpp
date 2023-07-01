#include <iostream>
#include <string>
#include <array>
#include <iomanip>

typedef std::pair<std::string, bool> data;

const std::array<const std::array<int32_t, 10>, 10>  multiplication_table = { {
	{ 0, 1, 2, 3, 4, 5, 6, 7, 8, 9 },
	{ 1, 2, 3, 4, 0, 6, 7, 8, 9, 5 },
	{ 2, 3, 4, 0, 1, 7, 8, 9, 5, 6 },
	{ 3, 4, 0, 1, 2, 8, 9, 5, 6, 7 },
	{ 4, 0, 1, 2, 3, 9, 5, 6, 7, 8 },
	{ 5, 9, 8, 7, 6, 0, 4, 3, 2, 1 },
	{ 6, 5, 9, 8, 7, 1, 0, 4, 3, 2 },
	{ 7, 6, 5, 9, 8, 2, 1, 0, 4, 3 },
	{ 8, 7, 6, 5, 9, 3, 2, 1, 0, 4 },
	{ 9, 8, 7, 6, 5, 4, 3, 2, 1, 0 }
} };

const std::array<int32_t, 10> inverse = { 0, 4, 3, 2, 1, 5, 6, 7, 8, 9 };

const std::array<const std::array<int32_t, 10>, 8> permutation_table = { {
    { 0, 1, 2, 3, 4, 5, 6, 7, 8, 9 },
    { 1, 5, 7, 6, 2, 8, 3, 0, 9, 4 },
    { 5, 8, 0, 3, 7, 9, 6, 1, 4, 2 },
    { 8, 9, 1, 6, 0, 4, 3, 5, 2, 7 },
    { 9, 4, 5, 3, 1, 2, 6, 8, 7, 0 },
    { 4, 2, 8, 6, 5, 7, 3, 9, 0, 1 },
	{ 2, 7, 9, 3, 8, 0, 6, 4, 1, 5 },
    { 7, 0, 4, 6, 9, 1, 3, 2, 5, 8 }
} };

int32_t verhoeff_checksum(std::string number, bool doValidation, bool doDisplay) {
	if ( doDisplay ) {
		std::string calculationType = doValidation ? "Validation" : "Check digit";
		std::cout << calculationType << " calculations for " << number << "\n" << std::endl;
		std::cout << " i  ni  p[i, ni]  c" << std::endl;
		std::cout << "-------------------" << std::endl;
	}

	if ( ! doValidation ) {
		number += "0";
	}

	int32_t c = 0;
	const int32_t le = number.length() - 1;
	for ( int32_t i = le; i >= 0; i-- ) {
		const int32_t ni = number[i] - '0';
		const int32_t pi = permutation_table[(le - i) % 8][ni];
		c = multiplication_table[c][pi];

		if ( doDisplay ) {
			std::cout << std::setw(2) << le - i << std::setw(3) << ni
					  << std::setw(8) << pi << std::setw(6) << c << "\n" << std::endl;
		}
	}

	if ( doDisplay && ! doValidation ) {
		std::cout << "inverse[" << c << "] = " << inverse[c] << "\n" << std::endl;;
	}

	return doValidation ? c == 0 : inverse[c];
}

int main( ) {
	const std::array<data, 3> tests = {
		std::make_pair("123", true), std::make_pair("12345", true), std::make_pair("123456789012", false) };

	for ( data test : tests ) {
		int32_t digit = verhoeff_checksum(test.first, false, test.second);
		std::cout << "The check digit for " << test.first << " is " << digit << "\n" << std::endl;

		std::string numbers[2] = { test.first + std::to_string(digit), test.first + "9" };
		for ( std::string number : numbers ) {
			digit = verhoeff_checksum(number, true, test.second);
			std::string result = ( digit == 1 ) ? "correct" : "incorrect";
			std::cout << "The validation for " << number << " is " << result << ".\n" << std::endl;
		}
	}
}
