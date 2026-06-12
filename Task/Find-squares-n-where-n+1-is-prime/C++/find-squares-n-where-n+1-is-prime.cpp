#include <cmath>
#include <cstdint>
#include <iostream>
#include <vector>

bool is_prime(const uint32_t& number) {
	if ( number % 2 == 0 ) {
		return number == 2;
	}

	uint32_t k = 3;
	while ( k * k <= number ) {
		if ( number % k == 0 ) {
			return false;
		}
		k += 2;
	}
	return true;
}

int main() {
	std::vector<uint32_t> squares;
	const uint32_t limit = std::sqrt(1'000);

	uint32_t i = 1;
	while ( i <= limit ) {
	    const uint32_t n = i * i;
	    if ( is_prime(n + 1) ) {
	    	squares.emplace_back(n);
	    }
	    i = ( i == 1 ) ? 2 : i + 2;
	}

	for ( const uint32_t square : squares ) {
		std::cout << square << " ";
	}
	std::cout << std::endl;
}
