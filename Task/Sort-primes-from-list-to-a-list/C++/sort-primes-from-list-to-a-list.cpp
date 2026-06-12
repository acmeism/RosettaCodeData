#include <algorithm>
#include <cstdint>
#include <iostream>
#include <iterator>
#include <ranges>
#include <vector>

bool is_prime(const uint32_t& number) {
	if ( number % 2 == 0 ) {
		return number == 2;
	}

	uint32_t k = 3;
	while ( k * k <= number ) {
		if ( number % k == 0 ) {
			return false;
		}
		k += 2;
	}
	return true;
}


int main() {
	const std::vector<uint32_t> elements = { 2, 43, 81, 122, 63, 13, 7, 95, 103 };
	std::vector<uint32_t> primes;

	for ( const uint32_t& element : elements ) {
		if ( is_prime(element) ) {
			primes.emplace_back(element);
		}
	}

	std::sort(primes.begin(), primes.end());
	std::ranges::copy(primes, std::ostream_iterator<uint32_t>(std::cout, " "));
}
