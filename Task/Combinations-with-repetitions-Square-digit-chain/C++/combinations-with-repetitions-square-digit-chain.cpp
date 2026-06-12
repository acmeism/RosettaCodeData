#include <cmath>
#include <cstdint>
#include <iostream>
#include <vector>

bool ends_with_one(uint32_t number) {
	uint32_t sum = 0;
	while ( true ) {
		while ( number > 0 ) {
			uint32_t digit = number % 10;
			sum += digit * digit;
			number /= 10;
		}

		if ( sum == 1 ) {
			return true;
		}
		if ( sum == 89 ) {
			return false;
		}
		number = sum;
		sum = 0;
	}
}

int main() {
	const std::vector<uint32_t> items = { 7, 8, 11, 14, 17 };
	for ( const uint32_t& k : items ) {
		std::vector<uint64_t> sums(k * 81 + 1, 0);
		sums[0] = 1;
		sums[1] = 0;
		for ( uint32_t n = 1; n <= k; ++n ) {
			for ( uint32_t i = n * 81; i >= 1; --i ) {
				for ( uint32_t j = 1; j <= 9; ++j ) {
					const uint64_t s = j * j;
					if ( s > i ) {
						break;
					}
					sums[i] += sums[i - s];
				}
			}
		}

		uint64_t count_ones = 0;
		for ( uint32_t i = 1; i <= k * 81; ++i ) {
			if ( ends_with_one(i) ) {
				count_ones += sums[i];
			}
		}

		const uint64_t limit = std::pow(10, k) - 1;
		std::cout << "For k = " << k << " in the range 1 to " << limit << std::endl;
		std::cout << count_ones << " numbers produce 1 and " << ( limit - count_ones ) << " numbers produce 89"
				  << std::endl << std::endl;
	}
}
