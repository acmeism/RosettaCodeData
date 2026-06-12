#include <cstdint>
#include <iomanip>
#include <iostream>
#include <string>
#include <vector>

const uint32_t sieve_size = 10'000;
const uint32_t maximum = 9 * std::to_string(sieve_size).length() * sieve_size;

std::vector<bool> is_consummate(sieve_size + 1, false);

uint32_t digital_sum(const uint32_t& number) {
	uint32_t result = 0;
	const std::string text = std::to_string(number);
	for ( const char ch : text ) {
		result += ch - (int) '0';
	}
	return result;
}

void create_is_consummate() {
	for ( uint32_t n = 1; n < maximum; ++n ) {
		uint32_t sum = digital_sum(n);
		if ( n % sum == 0 ) {
			uint32_t quotient = n / sum;
			if ( quotient <= sieve_size ) {
				is_consummate[quotient] = true;
			}
		}
	}
}

int main() {
	create_is_consummate();
	std::vector<uint32_t> inconsummates;
	for ( uint32_t i = 0; i <= sieve_size; ++i ) {
		if ( ! is_consummate[i] ) {
			inconsummates.emplace_back(i);
		}
	}

	std::cout << "The first 50 inconsummate numbers in base 10:" << std::endl;
	for ( uint32_t i = 1; i <= 50; ++i ) {
		std::cout << std::setw(3) << inconsummates[i] << ( i % 10 == 0 ? "\n" : " " );
	}
	std::cout << "\n" << "The 1,000 inconsummate number is " << inconsummates[1'000] << std::endl;
}
