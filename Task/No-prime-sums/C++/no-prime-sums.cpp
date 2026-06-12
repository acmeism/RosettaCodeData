#include <algorithm>
#include <cstdint>
#include <iostream>
#include <string>
#include <vector>

std::vector<uint32_t> primes;

template <typename T>
void print_vector(const std::vector<T>& vec) {
	std::cout << "[";
	for ( uint32_t i = 0; i < vec.size() - 1; ++i ) {
		std::cout << vec[i] << ", ";
	}
	std::cout << vec.back() << "]" << std::endl << std::endl;
}

void list_prime_numbers(const uint32_t& limit) {
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

enum Parity { BOTH, EVEN, ODD };

std::vector<uint32_t> no_prime_sums(const uint32_t& start, const uint32_t& limit, const Parity& parity) {
	const uint32_t step = ( parity == Parity::BOTH ) ? 1 : 2;
	uint32_t k = ( parity == Parity::EVEN ) ? 2 : 3;
	std::vector<uint32_t> sums = { 0, start };
	std::vector<uint32_t> result = { start };

	while ( result.size() < limit ) {
		do {
			bool valid = true;
			for ( const uint32_t& sum : sums ) {
				if ( std::binary_search(primes.begin(), primes.end(), sum + k) ) {
					valid = false;
					break; // for-next loop
				}
			}

			if ( valid ) {
				break; // do-while loop
			}

			k += step;
		} while ( true );

		if ( ( parity == Parity::EVEN && k % 2 == 0 ) ||
			 ( parity == Parity::ODD  && k % 2 == 1 ) ||
			   parity == Parity::BOTH ) {
			const uint32_t size = sums.size();
			for ( uint32_t i = 0; i < size; ++i ) {
				sums.emplace_back(sums[i] + k);
			}
			result.emplace_back(k);
		}

		k += step;
	}

	return result;
}

int main() {
	list_prime_numbers(100'000'000);
	constexpr uint32_t limit = 10;
	const std::vector<std::string> text = { "", "odd ", "even " };

	std::cout << "Sequence, starting with 1, then:" << std::endl << std::endl;
	for ( const Parity& parity : { Parity::BOTH, Parity::EVEN, Parity::ODD } ) {
		std::cout << "lexicographically earliest " << text[parity]
				  << "integer such that no subsequence sums to a prime: " << std::endl;
		print_vector(no_prime_sums(1, limit, parity));
	}
}
