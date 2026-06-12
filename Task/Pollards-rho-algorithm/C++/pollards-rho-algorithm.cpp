#include <bit>
#include <cmath>
#include <iostream>
#include <random>
#include <vector>

const uint32_t WORD_SIZE = 64;

std::random_device random;
std::mt19937 generator(random());

uint64_t gcd(uint64_t a, uint64_t b) {
    if ( a < b ) {
    	return gcd(b, a);
    }

    while ( b > 0 ) {
        const uint64_t temp = a % b;
        a = b;
        b = temp;
    }
    return a;
}

uint64_t pollards_rho(const uint64_t& number) {
	if ( number % 2 == 0 ) {
		return 2;
	}

	const uint32_t bit_length = WORD_SIZE - std::countl_zero(number);
	std::uniform_int_distribution<uint64_t> distribution(0, std::pow(2, bit_length - 1));
	const uint64_t constant = distribution(generator);
	uint64_t x = distribution(generator);
	uint64_t y = x;
	uint64_t divisor = 1;

	do {
		x = ( x * x + constant ) % number;
		y = ( y * y + constant ) % number;
		y = ( y * y + constant ) % number;
		divisor = gcd(x - y, number);
	} while ( divisor == 1 );

	return divisor;
}

int main() {
	const std::vector<uint64_t> tests = { 4294967213, 9759463979, 34225158206557151, 13 };

	for ( const uint64_t& test : tests ) {
		const uint64_t divisor_one = pollards_rho(test);
		const uint64_t divisor_two = test / divisor_one;
		std::cout << test << " = " << divisor_one << " * " << divisor_two << std::endl;
	}
}
