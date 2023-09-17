#include <cmath>
#include <cstdint>
#include <iostream>

uint32_t non_square(const uint32_t& n) {
    return n + static_cast<uint32_t>(0.5 + sqrt(n));
}

int main() {
	std::cout << "The first 22 non-square numbers:" << std::endl;
	for ( uint32_t i = 1; i <= 22; ++i ) {
		std::cout << non_square(i) << " ";
	}
	std::cout << std::endl << std::endl;

	uint32_t count = 0;
	for ( uint32_t i = 1; i < 1'000'000; ++i ) {
		double square_root = sqrt(non_square(i));
		if ( square_root == floor(square_root) ) {
			count++;
		}
	}
	std::cout << "Number of squares less than 1'000'000 produced by the formula: " << count << std::endl;
}
