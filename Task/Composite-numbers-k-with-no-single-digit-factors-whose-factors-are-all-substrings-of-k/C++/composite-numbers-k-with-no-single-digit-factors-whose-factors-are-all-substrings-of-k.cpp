#include <algorithm>
#include <cstdint>
#include <iostream>
#include <string>
#include <unordered_set>
#include <vector>

std::vector<uint32_t> primes;

void sieve_primes(const uint32_t& limit) {
	std::vector<bool> marked_prime(limit + 1, true);

	for ( uint32_t p = 2; p * p <= limit; ++p ) {
		if ( marked_prime[p] ) {
			for ( uint32_t i = p * p; i <= limit; i += p ) {
				marked_prime[i] = false;
			}
		}
	}

	for ( uint32_t p = 2; p <= limit; ++p ) {
		if ( marked_prime[p] ) {
			primes.emplace_back(p);
		}
	}
}

bool is_substring(const uint32_t& k, const uint32_t& factor) {
	const std::string string_k = std::to_string(k);
	const std::string string_factor = std::to_string(factor);
	return string_k.find(string_factor) != std::string::npos;
}

int main() {
	sieve_primes(30'000'000);

	std::unordered_set<uint32_t> distinct_factors;
	std::vector<uint32_t> result;
	uint32_t k = 11 * 11;

	while ( result.size() < 10 ) {
		while ( k % 3 == 0 || k % 5 == 0 || k % 7 == 0 ) {
			k += 2;
		}

		distinct_factors.clear();
		uint32_t copy_k = k;
		uint32_t index = 4;

		while ( copy_k > 1 ) {
			while ( copy_k % primes[index] == 0 ) {
				distinct_factors.insert(primes[index]);
				copy_k /= primes[index];
			}
			index += 1;
		}

		if ( distinct_factors.size() > 1 ) {
			if ( std::all_of(distinct_factors.begin(), distinct_factors.end(),
					[&k](uint32_t factor) { return is_substring(k, factor); }) ) {
				result.emplace_back(k);
			}
		}

		k += 2;
	}

	for ( uint64_t i = 0; i < result.size(); ++i ) {
		std::cout << result[i] << "  ";
	}
	std::cout << std::endl;
}
