#include <algorithm>
#include <cstdint>
#include <iomanip>
#include <iostream>
#include <string>
#include <vector>

struct Cousin_Prime {
	uint32_t lower_prime;
	uint32_t upper_prime;
	std::string text = "(" + std::to_string(lower_prime) + ", " + std::to_string(upper_prime) + ")";
};

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
	const uint32_t limit = 1'000;
	std::vector<uint32_t> primes = { };
	for ( uint32_t i = 2; i <= limit; ++i ) {
		if ( is_prime(i) ) {
			primes.emplace_back(i);
		}
	}

	std::vector<Cousin_Prime> cousins = { };
	for ( uint32_t i = 0; i < primes.size() - 1; ++i ) {
		if ( std::find(primes.begin(), primes.end(), primes[i] + 4) != primes.end() ) {
			cousins.emplace_back(Cousin_Prime(primes[i], primes[i] + 4));
		}
	}

	std::cout << "Number of cousin prime pairs less than " << limit << ": " << cousins.size() << std::endl;
	for ( uint64_t i = 0; i < cousins.size(); ++i ) {
		std::cout << std::setw(10) << cousins[i].text << ( ( i % 7 == 6 ) ? "\n" : " " );
	}
}
