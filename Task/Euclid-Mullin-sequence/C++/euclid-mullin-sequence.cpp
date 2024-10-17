#include <cstdint>
#include <iostream>

uint64_t product = 2;

uint64_t smallest_prime_factor(const uint64_t& number) {
	if ( number % 3 == 0 ) { return 3; }
	if ( number % 5 == 0 ) { return 5; }

	for ( uint64_t divisor = 7; divisor * divisor <= number; divisor += 2 ) {
		if ( number % divisor == 0 ) { return divisor; }
	}

	return number;
}

uint64_t next_euclid_mullin() {
	const uint64_t smallest_prime = smallest_prime_factor(product + 1);
	product *= smallest_prime;
	return smallest_prime;
}

int main() {
	std::cout << "The first 9 terms of the Euclid-Mullin sequence:" << "\n";
	std::cout << 2 << "  ";
	for ( uint32_t i = 1; i < 9; ++i ) {
		std::cout << next_euclid_mullin() << "  ";
	}
	std::cout << "\n";
}
