#include <cmath>
#include <cstdint>
#include <iomanip>
#include <iostream>
#include <vector>

std::vector<uint32_t> list_prime_numbers(const uint32_t& limit) {
	std::vector<uint32_t> primes{};
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
	return primes;
}

bool is_square(const uint32_t& number) {
	const uint32_t root = std::floor(std::sqrt(number));
	return root * root == number;
}

int main() {
	const std::vector<uint32_t> primes = list_prime_numbers(1'000'000);

	for ( uint32_t i = 2; i < primes.size(); ++i ) {
		const uint32_t prime2 = primes[i - 1];
		const uint32_t prime1 = primes[i];
		const uint32_t difference = prime1 - prime2;
		if ( difference > 36 && is_square(difference) ) {
			std::cout << std::setw(7) << prime2 << " and " << std::setw(6) << prime1
					  << " : difference = " << difference << std::endl;
		}
	}
}
