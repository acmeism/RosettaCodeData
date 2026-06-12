#include <cstdint>
#include <iostream>
#include <vector>

template <typename T>
void print_vector(const std::vector<T>& vec) {
	std::cout << "[";
	for ( uint32_t i = 0; i < vec.size() - 1; ++i ) {
		std::cout << vec[i] << ", ";
	}
	std::cout << vec.back() << "]" << std::endl;
}

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
	// Begin with 1 digit primes
	std::vector<uint32_t> primes = { 2, 3, 5, 7 };
	std::vector<uint32_t> composites;
	uint32_t test_count = 4; // Tests required to obtain the initial primes

	// Search for 2-digit substring primes
	std::vector<uint32_t> primes_copy(primes.begin(), primes.end());
	for ( uint32_t prime : primes_copy ) {
		// Additional digits must be 3 or 7 otherwise a composite substring would exist
		for ( uint32_t digit : { 3, 7 } ) {
			// If 'prime' and 'digit' are the same, 'number' would be divisible by 11
			if ( prime != digit ) {
				const uint32_t number = prime * 10 + digit;
				if ( is_prime(number) ) {
					primes.emplace_back(number);
				} else {
					composites.emplace_back(number);
				}
				test_count++;
			}
		}
	}

	// Search for 3-digit substring primes
	for ( uint32_t prime : primes ) {
		for ( uint32_t digit : { 3, 7 } ) {
			// Only test two digit 'primes'
			// If the last digit of 'prime' and 'digit' are the same, 'number' would be divisible by 11
			if ( 10 < prime && prime < 100 && prime % 10 != digit ) {
				const uint32_t number = prime * 10 + digit;
				if ( is_prime(number) ) {
					primes.emplace_back(number);
				} else {
					composites.emplace_back(number);
				}
				test_count++;
			}
		}
	}

	std::cout << "There are " << primes.size() << " primes where all substrings are also primes, namely: ";
	print_vector(primes);
	std::cout << "\nThe following numbers were tested for primality, but found to be composite: ";
	print_vector(composites);
	std::cout << "\nTotal number of primality tests: " << test_count << std::endl;
}
