#include <algorithm>
#include <cstdint>
#include <iostream>
#include <string>
#include <unordered_map>
#include <vector>

const std::vector<std::string> MAYAN_DIGITS = { " Θ  ", " ∙  ", " ∙∙ ", "∙∙∙ ", "∙∙∙∙", "────" };
const std::string BLANK = "    ";

std::unordered_map<std::string, std::string> BORDER { { "horizontal_beam", "═" }, { "vertical_beam", "║" },
	{ "lower_left", "╚" }, { "lower_central", "╩" }, { "lower_right", "╝" },
	{ "upper_left", "╔" }, { "upper_central", "╦" }, { "upper_right", "╗" }	};

std::vector<int32_t> to_base20(const int32_t& number) {
	std::vector<int32_t> result;
	result.emplace_back(number % 20);
	int32_t n = number / 20;
	while ( n != 0 ) {
		result.emplace_back(n % 20);
		n /= 20;
	}
	std::reverse(result.begin(), result.end());
	return result;
}

std::vector<std::string> to_mayan_numeral(int32_t digit) {
	std::vector<std::string> result(4, BLANK);
	if ( digit == 0 ) {
		result[3] = MAYAN_DIGITS[0];
		return result;
	}

	for ( int32_t i = 3; i >= 0; --i ) {
		if ( digit >= 5 ) {
			result[i] = MAYAN_DIGITS[5];
			digit -= 5;
		} else {
			result[i] = ( digit == 0 ) ? BLANK : MAYAN_DIGITS[digit];
			break;
		}
	}
	return result;
}

void display(const std::vector<std::vector<std::string>>& numerals) {
		const int32_t index = numerals.size() - 1;

		std::cout << BORDER["upper_left"];
		for ( int32_t i = 0; i <= index; ++i ) {
			for ( int32_t j = 0; j <= 3; ++j ) {
				std::cout << BORDER["horizontal_beam"];
			}
			if ( i < index ) {
				std::cout << BORDER["upper_central"];
			} else {
				std::cout << BORDER["upper_right"] << std::endl;
			}
		}

		for ( int32_t i = 1; i <= 4; ++i ) {
			std::cout << BORDER["vertical_beam"];
			for ( int32_t j = 0; j <= index; ++j ) {
				std::cout << numerals[j][i - 1] + BORDER["vertical_beam"];
			}
			std::cout << std::endl;
		}

		std::cout << BORDER["lower_left"];
		for ( int32_t i = 0; i <= index; ++i ) {
			for ( int32_t j = 0; j <= 3; ++j ) {
				std::cout << BORDER["horizontal_beam"];
			}
			if ( i < index ) {
				std::cout << BORDER["lower_central"];
			} else {
				std::cout << BORDER["lower_right"] << std::endl;
			}
		}
	}

int main() {
	for ( const int32_t& base10 : { 4'005, 8'017, 326'205, 886'205, 1'081'439'556 } ) {
		std::cout << "Base 10 number, " << base10 << " to Mayan:" << std::endl;
		std::vector<int32_t> digits = to_base20(base10);
		std::vector<std::vector<std::string>> mayans;
		for ( const int32_t& digit : digits ) {
			std::vector<std::string> mayan = to_mayan_numeral(digit);
			mayans.push_back(mayan);
		}
		display(mayans);
		std::cout << std::endl;
	}
}
