#include <algorithm>
#include <cmath>
#include <cstdint>
#include <iostream>
#include <numeric>
#include <vector>

void print_vector(const std::vector<int32_t>& list) {
	std::cout << "[";
	for ( uint64_t i = 0; i < list.size() - 1; ++i ) {
		std::cout << list[i] <<", ";
	}
	std::cout << list.back() << "]" << std::endl;
}

bool sum_of_distinct_squares(const int32_t& n, const std::vector<int32_t>& squares) {
	if ( n <= 0 ) {
		return false;
	}
	if ( find(squares.begin(), squares.end(), n) != squares.end() ) {
		return true;
	}

	const int32_t sum = std::accumulate(squares.begin(), squares.end(), 0);
	if ( n > sum ) {
		return false;
	}
	if ( n == sum ) {
		return true;
	}

	std::vector<int32_t> reversed_squares(squares);
	reversed_squares.erase(reversed_squares.end() - 1);
	std::reverse(reversed_squares.begin(), reversed_squares.end());

	return sum_of_distinct_squares(n - squares[squares.size() - 1], reversed_squares)
		|| sum_of_distinct_squares(n, reversed_squares);
}

int main() {
	std::vector<int32_t> squares;
	std::vector<int32_t> result;
	int32_t test_number = 1;
	int32_t previous_test_number = 1;
	while ( previous_test_number >= ( test_number >> 1 ) ) {
		const int32_t square_root = static_cast<int32_t>(std::sqrt(test_number));
		if ( square_root * square_root == test_number ) {
			squares.emplace_back(test_number);
		}
		if ( ! sum_of_distinct_squares(test_number, squares) ) {
			result.emplace_back(test_number);
			previous_test_number = test_number;
		}
		test_number++;
	}

	std::cout << "Numbers which are not the sum of distinct squares:" << std::endl;
	print_vector(result);
	std::cout << "\n" << "Stopped checking after finding " << ( test_number - previous_test_number )
		<< " sequential non-gaps after the final gap of " << previous_test_number << std::endl;
	std::cout << "Found " << result.size() << " numbers in total" << std::endl;
}
