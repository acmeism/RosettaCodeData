#include <algorithm>
#include <cstdint>
#include <iomanip>
#include <iostream>
#include <vector>

std::vector<uint32_t> initialise_klarner_rado_sequence(const uint32_t& limit) {
	std::vector<uint32_t> result(limit + 1);
	uint32_t i2 = 1, i3 = 1;
	uint32_t m2 = 1, m3 = 1;
	for ( uint32_t i = 1; i <= limit; ++i ) {
	   uint32_t minimum = std::min(m2, m3);
	   result[i] = minimum;;
	   if ( m2 == minimum ) {
		  m2 = result[i2] * 2 + 1;
		  i2++;
	   }
	   if ( m3 == minimum ) {
		  m3 = result[i3] * 3 + 1;
		  i3++;
	   }
	}
	return result;
}

int main() {
	const uint32_t limit = 1'000'000;
	std::vector<uint32_t> klarner_rado = initialise_klarner_rado_sequence(limit);

	std::cout << "The first 100 elements of the Klarner-Rado sequence:" << std::endl;
	for ( uint32_t i = 1; i <= 100; ++i ) {
		std::cout << std::setw(3) << klarner_rado[i] << ( i % 10 == 0 ? "\n" : " " );
	}
	std::cout << std::endl;

	uint32_t index = 1'000;
	while ( index <= limit ) {
		std::cout << "The " << index << "th element of Klarner-Rado sequence is " << klarner_rado[index] << std::endl;
		index *= 10;
	}
}
