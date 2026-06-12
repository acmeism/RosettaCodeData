#include <cstdint>
#include <iostream>

bool is_prime(const uint32_t& number) {
	if ( number % 2 == 0 ) {
		return number == 2;
	}
	int k = 3;
	while ( k * k <= number ) {
		if ( number % k == 0 ) {
			return false;
		}
		k += 2;
	}
	return true;
}

int main() {
	uint32_t i = 1;
	uint32_t prime = 2;
	std::cout << prime << " ";
	while ( true ) {
		while ( ! is_prime(prime + i * i) ) {
			i += 1;
		}
		prime += i * i;
		if ( prime > 16'000 ) {
			break;
		}
		std::cout << prime << " ";
		i = 1;
	}
	std::cout << std::endl;
}
