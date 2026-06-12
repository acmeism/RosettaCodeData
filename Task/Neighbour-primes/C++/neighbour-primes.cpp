#include <algorithm>
#include <cstdint>
#include <iostream>
#include <vector>

void fill_prime_numbers(const uint32_t& limit, std::vector<uint32_t>& primes) {
	primes.emplace_back(2);
	const uint32_t half_limit = ( limit + 1 ) / 2;
	std::vector<bool> composite(half_limit);
	for ( uint32_t i = 1, p = 3; i < half_limit; p += 2, ++i ) {
		if ( ! composite[i] ) {
			primes.emplace_back(p);
			for ( uint32_t a = i + p; a < half_limit; a += p ) {
				composite[a] = true;
			}
		}
	}
}

int main() {
	std::vector<uint32_t> primes;
	fill_prime_numbers(251'000, primes); // 499 * 499 = 249,001

	std::cout << "Neighbour primes less than 500: ";
	uint32_t i = 0;
	uint32_t p = primes[i];
	while ( p < 500 ) {
	    i++;
	    uint32_t q = primes[i];
	    if ( std::binary_search(primes.begin(), primes.end(), ( p * q + 2 )) ) {
	    	std::cout << p << " ";
	    }
	    p = q;
	}
	std::cout << std::endl;
}
