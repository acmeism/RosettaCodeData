#include <cstdint>
#include <iomanip>
#include <iostream>
#include <string>
#include <vector>

uint32_t honaker_index = 0;
uint32_t prime_index = 0;
std::vector<uint32_t> primes;

struct HonakerPrime {
	uint32_t honaker_index, prime_index, prime;

	std::string to_string() {
		return "(" + std::to_string(honaker_index) + ": "
				   + std::to_string(prime_index) + ", "
				   + std::to_string(prime) + ")";
	}
};

void sieve_primes(const uint32_t& limit) {
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

uint32_t digital_sum(uint32_t number) {
	uint32_t sum = 0;
	while ( number > 0 ) {
		sum += number % 10;
		number /= 10;
	}
	return sum;
}

HonakerPrime nextHonakerPrime() {
	honaker_index++;
	prime_index++;
	while ( digital_sum(prime_index) != digital_sum(primes[prime_index - 1]) ) {
		prime_index++;
	}
	return HonakerPrime(honaker_index, prime_index, primes[prime_index - 1]);
}

int main() {
	sieve_primes(5'000'000);

	std::cout << "The first 50 Honaker primes (honaker index: prime index, prime):" << std::endl;
	for ( uint32_t i = 1; i <= 50; ++i ) {
		std::cout << std::setw(17) << nextHonakerPrime().to_string() << ( i % 5 == 0 ? "\n" : " " );
	}
	for ( uint32_t i = 51; i < 10'000; ++i ) {
		nextHonakerPrime();
	}
	std::cout << "\n" << "The 10,000th Honaker prime is: " + nextHonakerPrime().to_string() << std::endl;
}
