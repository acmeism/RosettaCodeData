#include <algorithm>
#include <cstdint>
#include <iostream>
#include <iterator>
#include <ranges>
#include <vector>

void print_minimum_cells(const uint32_t& n) {
	std::cout << "Minimum number of cells after, before, above and below "
              << n << " x " << n << " square:" << std::endl;
	for ( uint32_t row = 0; row < n; ++row ) {
		std::vector<uint32_t> current_row{};
		for ( uint32_t col = 0; col < n; ++col ) {
			current_row.emplace_back( std::min({ n - row - 1, row, col, n - col - 1 }));
		}
		std::ranges::copy(current_row, std::ostream_iterator<int32_t>(std::cout, " "));
		std::cout << std::endl;
	}
}

int main() {
	print_minimum_cells(10);
}
