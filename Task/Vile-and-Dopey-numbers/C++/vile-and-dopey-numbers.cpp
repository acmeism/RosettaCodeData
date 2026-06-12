#include <cstdint>
#include <iomanip>
#include <iostream>
#include <vector>

bool is_vile(uint32_t n) {
	uint32_t count = 0;
	while ( ( n & 1 ) == 0 ) {
		n >>= 1;
		count += 1;
	}
	return count % 2 == 0;
}

int main() {
	std::vector<uint32_t> viles;
	std::vector<uint32_t> dopeys;

	uint32_t number = 1;
	while ( viles.size() < 25 || dopeys.size() < 25 ) {
		switch ( is_vile(number) ) {
			case true : viles.emplace_back(number); break;
			case false : dopeys.emplace_back(number); break;
		};
		number += 1;
	}

	std::cout << "The first 25 Vile numbers:" << std::endl;
	for ( uint32_t i = 0; i < 25; ++i ) {
		std::cout << viles[i] << "  ";
	}
	std::cout << "\n\nThe first 25 Dopey numbers:" << std::endl;
	for ( uint32_t i = 0; i < 25; ++i ) {
			std::cout << dopeys[i] << "  ";
		}

	std::cout << "\n\nUpto:  Vile  Dopey" << std::endl;
	uint32_t limit = 2;
	uint32_t vile_count = 0;
	uint32_t dopey_count = 0;
	uint32_t n = 1;
	while ( n <= limit && limit <= 1024 ) {
		switch ( is_vile(n) ) {
			case true : vile_count += 1; break;
			case false : dopey_count += 1; break;
		};
		if ( n == limit ) {
			std::cout << std::setw(4) << limit << ":   " << std::setw(3) << vile_count
					  << "    " << std::setw(3) << dopey_count << std::endl;
			limit *= 2;
		}
		n += 1;
	}
}
