#include <algorithm>
#include <cstdint>
#include <iomanip>
#include <iostream>
#include <vector>

void display(const std::vector<std::vector<int32_t>>& matrix) {
	for ( const std::vector<int32_t>& row : matrix ) {
		for ( const int32_t& element : row ) {
			std::cout << std::setw(3) << element;
		}
		std::cout << std::endl;;
	}
	std::cout << std::endl;;
}

uint32_t sign_change_count(const std::vector<int32_t>& row) {
	uint32_t sign_changes = 0;
	for ( uint64_t i = 1; i < row.size(); ++i ) {
		if ( row[i - 1] == -row[i] ) {
			sign_changes++;
		}
	}
	return sign_changes;
}

std::vector<std::vector<int32_t>> walsh_matrix(const uint32_t& size) {
	std::vector<std::vector<int32_t>> walsh = { size, std::vector<int32_t>(size, 0) };
	walsh[0][0] = 1;

	uint32_t k = 1;
	while ( k < size ) {
		for ( uint32_t i = 0; i < k; ++i ) {
			for ( uint32_t j = 0; j < k; ++j ) {
				walsh[i + k][j] = walsh[i][j];
				walsh[i][j + k] = walsh[i][j];
				walsh[i + k][j + k] = -walsh[i][j];
			}
		}
		k += k;
	}
	return walsh;
}

int main() {
	for ( const std::string type : { "Natural", "Sequency" } ) {
		for ( const uint32_t order : { 2, 4, 5 } ) {
			uint32_t size = 1 << order;
			std::cout << "Walsh matrix of order " << order << ", " << type << " order:" << std::endl;
			std::vector<std::vector<int32_t>> walsh = walsh_matrix(size);
			if ( type == "Sequency" ) {
				std::sort(walsh.begin(), walsh.end(),
					[](const std::vector<int32_t> &row1, const std::vector<int32_t> &row2) {
						return sign_change_count(row1) < sign_change_count(row2);
					});
			}
			display(walsh);
		}
	}
}
