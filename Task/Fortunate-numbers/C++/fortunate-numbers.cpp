#include <algorithm>
#include <cstdint>
#include <iostream>
#include <set>
#include <vector>

std::vector<int32_t> prime_numbers(const int32_t& limit) {
	const int32_t half_limit = ( limit % 2 == 0 ) ? limit / 2 : 1 + limit / 2;
	std::vector<bool> composite(half_limit, false);
	for ( int32_t i = 1, p = 3; i < half_limit; p += 2, ++i ) {
		if ( ! composite[i] ) {
			for ( int32_t a = i + p; a < half_limit; a += p ) {
				composite[a] = true;
			}
		}
	}

	std::vector<int32_t> primes{2};
	for ( int32_t i = 1, p = 3; i < half_limit; p += 2, ++i ) {
		if ( ! composite[i] ) {
			primes.push_back(p);
		}
	}
	return primes;
}

bool contains(const std::vector<int32_t>& list, const int32_t& n) {
	return std::find(list.begin(), list.end(), n) != list.end();
}

int main() {
	std::vector<int32_t> primes = prime_numbers(250'000'000);
	std::set<int32_t> fortunates;
	int32_t primorial = 1;
	int32_t index = 0;

	while ( fortunates.size() < 8 ) {
		primorial *= primes[index++];
		int32_t candidate = 3;
		while ( ! contains(primes, primorial + candidate) ) {
			candidate += 2;
		}
		fortunates.emplace(candidate);
	}

	std::cout << "The first 8 distinct fortunate numbers are:" << std::endl;
	for ( const int32_t& fortunate : fortunates ) {
		std::cout << fortunate << " ";
	}
}
