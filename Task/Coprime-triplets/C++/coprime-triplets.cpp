#include <algorithm>
#include <cstdint>
#include <iostream>
#include <numeric>
#include <vector>

int main() {
	std::vector<uint32_t> coprimes = { 1, 2 };

	uint32_t n = 3;
	while ( n < 50 ) {
		n = 3;
		const uint32_t previous2 = coprimes[coprimes.size() - 2];
		const uint32_t previous1 = coprimes[coprimes.size() - 1];
		while ( std::find(coprimes.begin(), coprimes.end(), n) != coprimes.end()
			|| std::gcd(n, previous2) != 1 || std::gcd(n, previous1) != 1 ) {
			n += 1;
		}
		if ( n < 50 ) {
			coprimes.emplace_back(n);
		}
	}

	for ( const uint32_t& n : coprimes ) {
		std::cout << n << " ";
	}
	std::cout << std::endl;
}
