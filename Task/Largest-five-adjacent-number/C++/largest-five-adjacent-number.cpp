#include <cstdint>
#include <iostream>
#include <random>
#include <string>

std::random_device random;
std::mt19937 generator(random());

int main() {
	std::string digits = "";
	std::uniform_int_distribution<int32_t> distribution19(1, 9);
	digits += std::to_string(distribution19(generator));
	std::uniform_int_distribution<int32_t> distribution09(0, 9);
	for ( uint32_t i = 0; i < 999; ++i ) {
		digits += std::to_string(distribution09(generator));
	}

	uint32_t maximum = 0;
	uint32_t minimum = INT32_MAX;
	for ( uint32_t i = 0; i < digits.length() - 4; ++i ) {
		const uint32_t number = std::stoi(digits.substr(i, 5));
		if ( number > maximum ) {
			maximum = number;
		}
		if ( number < minimum ) {
			minimum = number;
		}
	}

	std::cout << "Maximum = " << maximum << " and minimum = " << minimum << std::endl;
}
