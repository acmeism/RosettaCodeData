#include <cmath>
#include <cstdint>
#include <iomanip>
#include <iostream>
#include <numeric>
#include <vector>

struct PrimePower {
	uint32_t prime;
	uint32_t power;
};

std::vector<PrimePower> prime_powers(const uint32_t& number) {
	std::vector<PrimePower> powers{};

	uint32_t n = number;
	for ( uint32_t i = 2; i <= std::sqrt(n); ++i ) {
		if ( n % i == 0 ) {
			powers.emplace_back(PrimePower(i, 0));
			while ( n % i == 0 ) {
				powers.back().power += 1;
				n /= i;
			}
		}
	}

	if ( n > 1 ) {
		powers.emplace_back(PrimePower(n, 1));
	}
	return powers;
}

uint32_t carmichael_lambda(const uint32_t& number) {
	if ( number == 1 ) {
		return 1;
	}

	std::vector<PrimePower> powers = prime_powers(number);
	uint32_t result = 1;
	for ( PrimePower primePower : powers ) {
		 uint32_t car = ( primePower.prime - 1 ) * std::pow(primePower.prime, primePower.power - 1);
		 if ( primePower.prime == 2 && primePower.power >= 3 ) {
			 car /= 2;
		 }
		 result = std::lcm(result, car);
	}
	return result;
}

uint32_t count_iterations_to_one(const uint32_t& n) {
	return ( n <= 1 ) ? 0 : count_iterations_to_one(carmichael_lambda(n)) + 1;
}

int main() {
	std::cout << " n   carmichael(n) iterations(n)" << std::endl;
	std::cout << "--------------------------------" << std::endl;
	for ( uint32_t i = 1; i <= 25; ++i ) {
		std::cout << std::setw(2) << i << std::setw(10) << carmichael_lambda(i)
				  << std::setw(14) << count_iterations_to_one(i) << std::endl;
	}
	std::cout << std::endl;

	std::cout << "Iterations to 1     n     lambda(n)" << std::endl;
	std::cout << "-----------------------------------" << std::endl;
	uint32_t n = 1;
	for ( uint32_t i = 0; i <= 15; ++i ) {
		while ( count_iterations_to_one(n) != i ) {
			n += 1;
		}
		std::cout << std::setw(2) << i << std::setw(19) << n << std::setw(13) << carmichael_lambda(n) << std::endl;
	}
}
