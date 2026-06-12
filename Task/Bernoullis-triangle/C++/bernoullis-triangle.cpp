#include <cstdint>
#include <iomanip>
#include <iostream>
#include <vector>

int main() {
	std::vector<uint32_t> previous_row;

	for ( uint32_t n = 0; n < 15; ++n ) {
		std::vector<uint32_t> current_row;
		for ( uint32_t k = 0; k <= n; ++k ) {
			if ( k == 0 ) {
				current_row.emplace_back(1);
			} else if ( k < n ) {
				current_row.emplace_back(previous_row[k] + previous_row[k - 1]);
			} else {
				current_row.emplace_back(2 * previous_row.back());
			}
		}

		for ( const uint32_t& entry : current_row ) {
			std::cout << std::left << std::setw(6) << entry;
		}
		std::cout << std::endl;

		previous_row = current_row;
	}
}
