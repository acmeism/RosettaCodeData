#include <algorithm>
#include <cstdint>
#include <iomanip>
#include <iostream>
#include <vector>

std::vector<uint32_t> primes;

void fill_primes(const uint32_t& limit) {
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

bool is_prime(const uint32_t& n) {
	return std::binary_search(primes.begin(), primes.end(), n) > 0;
}

bool is_happy(uint32_t n) {
	while ( n != 1 && n != 4 ) {
		uint32_t sum = 0;
		for ( const char& ch : std::to_string(n) ) {
			const uint32_t i = ch - '0';
			sum += i * i;
		}
		n = sum;
	}
	return n == 1;
}

int main() {
	fill_primes(10'000'000);

	std::cout << "The first fifty happy primes:" << std::endl;
	uint32_t n = 1;
	uint32_t count = 0;
	while ( count < 50 ) {
		if ( is_happy(n) && is_prime(n) ) {
			count++;
			std::cout << std::setw(4) << n << ( count % 10 == 0 ? "\n" : " " );
		}
		n++;
	}

	std::cout << "\nPrime\nfraction  Index    Value" << std::endl;
	uint32_t number = 1;
	uint32_t happy_count = 0;
	uint32_t prime_count = 0;
	uint32_t denominator = 2;
	while ( denominator <= 15 ) {
		if ( is_happy(number) ) {
			happy_count++;
			if ( is_prime(number) ) {
				prime_count++;
			}
			if ( static_cast<double>(prime_count) / happy_count <= 1.0 / denominator ) {
				std::cout << "1 / " << std::setw(2) << denominator << "  " << std::setw(6) << happy_count
						  << "  " << std::setw(7) << number << std::endl;
				denominator++;
			}
		}

		number++;
	}
}
