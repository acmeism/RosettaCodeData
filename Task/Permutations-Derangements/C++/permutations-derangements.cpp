#include <cstdint>
#include <iomanip>
#include <iostream>
#include <numeric>
#include <vector>

typedef std::pair<std::vector<std::vector<int32_t>>, int32_t> list_or_count;

uint64_t factorial(const int32_t& n) {
	uint64_t result = 1;
	for ( int32_t i = 2; i <= n; ++i ) {
		result *= i;
	}
	return result;
}

uint64_t subfactorial(const int32_t& n) {
	if ( n >= 0 && n <= 2 ) {
		return ( n == 1 ) ? 0 : 1;
	}
	return ( n - 1 ) * ( subfactorial(n - 1) + subfactorial(n - 2) );
}

list_or_count derangements(const int32_t& n, const bool& count_only) {
	std::vector<int32_t> sequence(n, 0);
	std::iota(sequence.begin() ,sequence.end(), 1);
	std::vector<int32_t> original(sequence);
	uint64_t permutation_count = factorial(n);

	std::vector<std::vector<int32_t>> list;
	int32_t count = ( n == 0 ) ? 1 : 0;

	while ( --permutation_count > 0 ) {
		int32_t j = n - 2;
		while ( sequence[j] > sequence[j + 1] ) {
			j--;
		}
		int32_t k = n - 1;
		while ( sequence[j] > sequence[k] ) {
			k--;
		}
		std::swap(sequence[j], sequence[k]);

		int32_t r = n - 1;
		int32_t s = j + 1;
		while ( r > s ) {
			std::swap(sequence[r], sequence[s]);
			r--;
			s++;
		}

		j = 0;
		while ( j < n && sequence[j] != original[j] ) {
			j++;
		}
		if ( j == n ) {
			if ( count_only ) {
				count++;
			} else {
				std::vector<int32_t> copy_sequence(sequence);
				list.emplace_back(copy_sequence);
			}
		}
	}
	return list_or_count(list, count);
}

int main() {
	std::cout << "Derangements for n = 4" << std::endl;
	list_or_count list_count = derangements(4, false);
	for ( std::vector<int32_t> list : list_count.first ) {
		std::cout << "[";
		for ( uint64_t i = 0; i < list.size() - 1; ++i ) {
			std::cout << list[i] << ", ";
		}
		std::cout << list.back() << "]" << std::endl;
	}
	std::cout << std::endl;

	std::cout << "n   derangements      !n" << std::endl;
	std::cout << "------------------------" << std::endl;
	for ( int32_t n = 0; n < 10; ++n ) {
		int32_t count = derangements(n, true).second;
		std::cout << n << ":  " << std::setw(9) << count << "  " << std::setw(9) << subfactorial(n) << std::endl;
	}
	std::cout << std::endl;

	std::cout << "!20 = " << subfactorial(20) << std::endl;
}
