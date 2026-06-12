#include <algorithm>
#include <cstdint>
#include <iomanip>
#include <iostream>
#include <vector>

std::vector<uint32_t> primes{ };

void fill_primes(const uint64_t& limit) {
	primes.emplace_back(2);
	const uint32_t half_limit = ( limit + 1 ) / 2;
	std::vector<bool> composite(half_limit, false);
	for ( uint32_t i = 1, p = 3; i < half_limit; p += 2, ++i ) {
		if ( ! composite[i] ) {
			primes.emplace_back(p);
			for ( uint32_t a = i + p; a < half_limit; a += p ) {
				composite[a] = true;
			}
		}
	}
}

bool is_prime(const uint32_t& candidate) {
	return std::binary_search(primes.begin(), primes.end(), candidate);
}

uint32_t next_prime(const uint32_t& prime) {
	return *++std::find(primes.begin(), primes.end(), prime);
}

int main() {
	fill_primes(300'000);
	std::vector<uint32_t> extreme_primes = { 2 };
	uint32_t sum = 2;
	uint32_t prime = 3;
	uint32_t count = 1;

	while ( count < 30 ) {
		sum += prime;
		if ( is_prime(sum) ) {
			count += 1;
			extreme_primes.emplace_back(sum);
		}
		prime = next_prime(prime);
	}

	std::cout << "The first 30 extreme primes are:" << std::endl;
	for ( uint32_t i = 0; i < extreme_primes.size(); ++i ) {
		std::cout << std::setw(7) << extreme_primes[i] << ( i % 6 == 5 ? "\n" : " " );
	}
	std::cout << std::endl;
}
