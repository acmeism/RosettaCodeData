#include <cstdint>
#include <iomanip>
#include <iostream>
#include <string>
#include <vector>

uint32_t lempel_ziv_complexity(const std::string& text) {
	if ( text.empty() ) {
		return 0;
	}

	uint32_t complexity = 0;
	uint32_t pointer = 0;

	while ( pointer < text.length() ) {
		complexity++;
		uint32_t k = 1;
		while ( pointer + k <= text.length() ) {
			const std::string substring = text.substr(pointer, k);
			const std::string search_window = text.substr(0, pointer + k - 1);

			if ( search_window.find(substring) != std::string::npos ) {
				k += 1;
			} else {
				pointer += k;
				k = 0;
				break;
			}
		}

		if ( pointer + k > text.length() ) {
			pointer = text.length();
		}
	}

	return complexity;
}

int main() {
	const std::vector<std::string> tests = { "AZSEDRFTGYGUJIJOKB",
					                         "ABCABCABCABCABCABC",
					                         "111011111001111011111001",
											 "101001010010111110",
											 "1001111011000010",
											 "1010101010",
											 "1010101010101010",
											 "1001111011000010000010",
											 "100111101100001000001010",
											 "0001101001000101",
											 "1111111",
											 "0001",
											 "010",
											 "1",
											 "",
											 "01011010001101110010",
											 "ABCDEFGHIJKLMNOPQRSTUVWXYZ",
											 "HELLO WORLD! HELLO WORLD! HELLO WORLD! HELLO WORLD!" };

	std::cout << std::left << std::setw(52) << "String" << "LZ Complexity" << std::endl;
	std::cout << std::string(65, '=') << std::endl;

	for ( const std::string& test : tests ) {
		std::cout << std::left << std::setw(52) << test << lempel_ziv_complexity(test) << std::endl;
	}
}
