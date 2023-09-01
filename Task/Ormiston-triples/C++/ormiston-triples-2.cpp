#include <algorithm>
#include <cmath>
#include <cstdint>
#include <iomanip>
#include <iostream>
#include <vector>

class SegmentedPrimeIterator {
public:
	SegmentedPrimeIterator(const uint64_t& aLimit) {
		square_root = std::sqrt(aLimit);
		index = 0;
        low = 0;
        high = square_root;
        small_sieve(square_root);
	}

	uint64_t next() {
		if ( index == primes.size() ) {
			index = 0;
			segmented_sieve();
		}
		return primes[index++];
	}

private:
	void segmented_sieve() {
		low += square_root;
		high += square_root;

		std::vector<bool> marked_prime(square_root, true);

		for ( uint64_t i = 0; i < small_primes.size(); ++i ) {
			uint64_t low_limit = ( low / small_primes[i] ) * small_primes[i];
			if ( low_limit < low ) {
				low_limit += small_primes[i];
			}

			for ( uint64_t j = low_limit; j < high; j += small_primes[i] ) {
				marked_prime[j - low] = false;
			}
		}

		primes.clear();
		for ( uint64_t i = low; i < high; ++i ) {
			if ( marked_prime[i - low] ) {
				primes.emplace_back(i);
			}
		}
	}

	void small_sieve(const uint32_t& square_root) {
		std::vector<bool> marked_prime(square_root + 1, true);

		for ( uint32_t p = 2; p * p <= square_root; ++p ) {
			if ( marked_prime[p] ) {
				for ( uint32_t i = p * p; i <= square_root; i += p ) {
					marked_prime[i] = false;
				}
			}
		}

		for ( uint32_t p = 2; p <= square_root; ++p ) {
			if ( marked_prime[p] ) {
				primes.emplace_back(p);
			}
		}
		small_primes.insert(small_primes.end(), primes.begin(), primes.end());
	}

	uint32_t index, square_root;
	uint64_t low, high;
	std::vector<uint64_t> primes;
	std::vector<uint64_t> small_primes;
};

std::vector<uint32_t> digits(uint64_t number) {
	std::vector<uint32_t> result;
	while ( number > 0 ) {
		result.emplace_back(number % 10);
		number /= 10;
	}
	std::sort(result.begin(), result.end());
	return result;
}

bool haveSameDigits(uint64_t first, uint64_t second) {
	return digits(first) == digits(second);
}

int main() {
	const uint64_t limit = 10'000'000'000;
	SegmentedPrimeIterator primes(limit);
	std::vector<uint64_t> ormistons;
	uint64_t lower_limit = limit / 10;
	uint32_t count = 0;
	std::vector<uint32_t> counts;
	uint64_t p1 = 0, p2 = 0, p3 = 0;

	while ( p3 < limit ) {
		p1 = p2; p2 = p3; p3 = primes.next();

		if ( ( p2 - p1 ) % 18 != 0 || ( p3 - p2 ) % 18 != 0 ) {
			continue;
		}

		if ( ! haveSameDigits(p1, p2) ) {
			continue;
		}

		if ( haveSameDigits(p2, p3) ) {
			if ( count < 25 ) {
				ormistons.emplace_back(p1);
			}
			if ( p1 >= lower_limit ) {
				counts.emplace_back(count);
				lower_limit *= 10;
			}
			count += 1;
		}
	}
	counts.emplace_back(count);

	std::cout << "The smallest member of the first 25 Ormiston triples:" << std::endl;
	for ( uint64_t i = 0; i < ormistons.size(); ++i ) {
		std::cout << std::setw(10) << ormistons[i] << ( i % 5 == 4 ? "\n" : "" );
	}
	std::cout << std::endl;

	lower_limit = limit / 10;
	for ( uint64_t i = 0; i < counts.size(); ++i ) {
		std::cout << counts[i] << " Ormiston triples less than " << lower_limit << std::endl;
		lower_limit *= 10;
	}
}
