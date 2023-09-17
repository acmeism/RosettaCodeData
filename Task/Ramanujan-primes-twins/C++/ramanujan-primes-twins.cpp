#include <cmath>
#include <cstdint>
#include <iostream>
#include <vector>

int32_t ramanujan_maximum(const int32_t& number) {
	return ceil(4 * number * log(4 * number));
}

std::vector<int32_t> initialise_prime_pi(const int32_t& limit) {
	std::vector<int32_t> result(limit, 1);
	result[0] = 0;
	result[1] = 0;
	for ( int32_t i = 4; i < limit; i += 2 ) {
		result[i] = 0;
	}
	for ( int32_t p = 3, square = 9; square < limit; p += 2 ) {
		if ( result[p] != 0 ) {
			for ( int32_t q = square; q < limit; q += p << 1 ) {
				result[q] = 0;
			}
		}
		square += ( p + 1 ) << 2;
	}

	for ( uint64_t i = 1; i < result.size(); ++i ) {
		result[i] += result[i - 1];
	}
	return result;
}

int32_t ramanujan_prime(const std::vector<int32_t>& prime_pi, const int32_t& number) {
	int32_t maximum = ramanujan_maximum(number);
	if ( ( maximum & 1) == 1 ) {
		maximum -= 1;
	}

	int32_t index = maximum;
	while ( prime_pi[index] - prime_pi[index / 2] >= number ) {
		index -= 1;
	}
	return index + 1;
}

std::vector<int32_t> list_primes_less_than(const int32_t& limit) {
	std::vector<bool> composite(limit, false);
	int32_t n = 3;
	int32_t nSquared = 9;
	while ( nSquared <= limit ) {
		if ( ! composite[n] ) {
			for ( int32_t k = nSquared; k < limit; k += 2 * n ) {
				composite[k] = true;
			}
		}
		nSquared += ( n + 1 ) << 2;
		n += 2;
	}

	std::vector<int32_t> result;
	result.emplace_back(2);
	for ( int32_t i = 3; i < limit; i += 2 ) {
		if ( ! composite[i] ) {
			result.emplace_back(i);
		}
	}
	return result;
}

int main() {
	const int32_t limit = 1'000'000;
	const std::vector<int32_t> prime_pi = initialise_prime_pi(ramanujan_maximum(limit) + 1);
	const int32_t millionth_ramanujan_prime = ramanujan_prime(prime_pi, limit);
	std::cout << "The 1_000_000th Ramanujan prime is " << millionth_ramanujan_prime << std::endl;

	std::vector<int32_t> primes = list_primes_less_than(millionth_ramanujan_prime);
	std::vector<int32_t> ramanujan_prime_indexes(primes.size());
	for ( uint64_t i = 0; i < ramanujan_prime_indexes.size(); ++i ) {
		ramanujan_prime_indexes[i] = prime_pi[primes[i]] - prime_pi[primes[i] / 2];
	}

	int32_t lowerLimit = ramanujan_prime_indexes[ramanujan_prime_indexes.size() - 1];
	for ( int32_t i = ramanujan_prime_indexes.size() - 2; i >= 0; --i ) {
		if ( ramanujan_prime_indexes[i] < lowerLimit ) {
			lowerLimit = ramanujan_prime_indexes[i];
		} else {
			ramanujan_prime_indexes[i] = 0;
		}
	}

	std::vector<int32_t> ramanujan_primes;
	for ( uint64_t i = 0; i < ramanujan_prime_indexes.size(); ++i ) {
		if ( ramanujan_prime_indexes[i] != 0 ) {
			ramanujan_primes.emplace_back(primes[i]);
		}
	}

	int32_t twins_count = 0;
	for ( uint64_t i = 0; i < ramanujan_primes.size() - 1; ++i ) {
		if ( ramanujan_primes[i] + 2 == ramanujan_primes[i + 1] ) {
			twins_count++;
		}
	}
	std::cout << "There are " << twins_count << " twins in the first " << limit << " Ramanujan primes." << std::endl;
}
