#include <cstdint>
#include <iostream>
#include <vector>

int main() {
	constexpr uint32_t limit = 500'000;
	std::vector<uint32_t> divisor_sums(limit + 1, 0);
	for ( uint32_t i = 1; i <= limit; ++i ) {
		for ( uint32_t j = i; j <= limit; j += i ) {
			divisor_sums[j] += i;
		}
	}

	uint32_t count = 0;
	for ( uint32_t i = 0; i < limit; ++i ) {
		if ( divisor_sums[i] == divisor_sums[i + 1] ) {
			std::cout << ++count << ": " << i << std::endl;
		}
	}
}
