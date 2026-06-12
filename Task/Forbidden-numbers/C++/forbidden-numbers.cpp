#include <algorithm>
#include <cmath>
#include <cstdint>
#include <iomanip>
#include <iostream>
#include <iterator>
#include <vector>

bool is_forbidden(const uint32_t& number) {
	uint32_t copy_number = number;
	uint32_t power_of_4 = 0;
	while ( copy_number > 1 && copy_number % 4 == 0 ) {
		copy_number /= 4;
		power_of_4++;
	}
	return ( number / static_cast<uint32_t>(std::pow(4, power_of_4)) ) % 8 == 7;
}

int main() {
	std::vector<uint32_t> forbiddens = { };
	for ( uint32_t i = 1; i <= 500'000; ++i ) {
		if ( is_forbidden(i) ) {
			forbiddens.emplace_back(i);
		}
	}

	std::cout << "The first 50 forbidden numbers are:" << "\n";
	for ( uint32_t n = 0; n < 50; ++n ) {
		std::cout << std::setw(3) << forbiddens[n] << ( n % 10 == 9 ? "\n" : " " );
	}
	std::cout << "\n";

	for ( uint32_t limit : { 500, 5'000, 50'000, 500'000 } ) {
		const auto iter = std::lower_bound(forbiddens.begin(), forbiddens.end(), limit);
		const uint32_t count = std::distance(forbiddens.begin(), iter);
	    std::cout << "There are " << count << " forbidden number count <= " << limit << "\n";
	}
}
