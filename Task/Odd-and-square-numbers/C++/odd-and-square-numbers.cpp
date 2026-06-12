#include <cmath>
#include <cstdint>
#include <iostream>

int main() {
	for ( uint32_t n = 11; n <= std::sqrt(1'000); n += 2 ) {
		std::cout << n * n << std::endl;
	}
}
