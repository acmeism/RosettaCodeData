#include <cstdint>
#include <iomanip>
#include <iostream>

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
	std::cout << "  i  p(i)  sum" << std::endl;
	std::cout << "---------------" << std::endl;
	uint32_t index = 0;
	uint32_t sum = 0;
	uint32_t p = 1;

	while ( p < 1'000 ) {
		p++;
		if ( is_prime(p) ) {
			index++;
			if ( index % 2 == 1 ) {
				sum += p;
				if ( is_prime(sum) ) {
					std::cout << std::setw(3) << index << std::setw(5) << p << std::setw(7) << sum << std::endl;
				}
			}
		}
	}
}
