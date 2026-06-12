#include <cstdint>
#include <iomanip>
#include <iostream>
#include <vector>

void list_prime_numbers(const uint32_t& limit, std::vector<uint32_t>& primes) {
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
	list_prime_numbers(200'000'000, primes);

	std::cout << "The first 20 pairs of natural numbers whose sum is prime:" << std::endl;
	for ( uint32_t i = 1; i <= 20; ++i ) {
		const uint32_t prime = primes[i];
		const uint32_t half_prime = prime / 2;
		std::cout << std::setw(2) << half_prime << " + " << half_prime + 1 << " = " << prime << std::endl;
	}
	std::cout << std::endl;

	std::cout << "The 10 millionth such pair is:" << std::endl;
	const uint32_t prime = primes[10'000'000];
	const uint32_t half_prime = prime / 2;
	std::cout << std::setw(2) << half_prime << " + " << half_prime + 1 << " = " << prime << std::endl;
}
