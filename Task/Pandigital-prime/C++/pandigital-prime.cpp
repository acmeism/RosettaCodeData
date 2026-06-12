#include <cstdint>
#include <iostream>
#include <string>

void pandigital_prime(const char& n) {
	const uint32_t start = ( n == '1' ) ? 7654321 : 76543201;
	uint32_t test = start + 18;
	bool searching = true;

	while ( searching ) {
		test -= 18;
		std::string value = std::to_string(test);
		bool pandigital = true;
		for ( char ch = n; ch <= '7' && pandigital; ++ch ) {
			if ( value.find(ch) == std::string::npos ) {
				pandigital = false;
			}
		}

		if ( ! pandigital ) {
			continue;
		}

		if ( test % 3 == 0 ) {
			continue;
		}

		uint32_t divisor = 1;
		bool divisible = false;
		while ( divisor * divisor < test ) {
			if ( test % ( divisor += 4 ) == 0 || test % ( divisor += 2 ) == 0 ) {
				divisible = true;
			}
		}

		if ( divisible ) {
			continue;
		}

		searching = false;
		const std::string suffix = ( n == '1' ) ? "" : "0";
		std::cout << "The largest pandigital" << suffix << " prime is: " << test << std::endl;
	}
}

int main() {
	pandigital_prime('1');
	pandigital_prime('0');
}
