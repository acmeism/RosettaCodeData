#include <cstdint>
#include <iostream>
#include <set>
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

std::vector<uint32_t> proper_divisors(const uint32_t& number) {
	std::set<uint32_t> proper_divisors{};

	uint32_t divisor = 2;
	while ( divisor * divisor <= number ) {
		if ( number % divisor == 0 ) {
			proper_divisors.insert(divisor);
			proper_divisors.insert(number / divisor);
		}
		divisor += 1;
	}

	std::vector<uint32_t> result(proper_divisors.begin(), proper_divisors.end());
	return result;
}

bool is_calmo_number(const uint32_t& number) {
	std::vector<uint32_t> prop_divisors = proper_divisors(number);
	if ( prop_divisors.empty() || prop_divisors.size() % 3 != 0 ) {
		return false;
	}

	for ( uint32_t i = 0; i < prop_divisors.size(); i += 3 ) {
		if ( ! is_prime(prop_divisors[i] + prop_divisors[i + 1] + prop_divisors[i + 2]) ) {
			return false;
		}
	}
	return true;
}

int main() {
	std::cout << "Calmo numbers less than 1,000:";
	for ( uint32_t n = 1; n < 1'000; ++n ) {
		if ( is_calmo_number(n) ) {
			std::cout << " " << n;
		}
	}
	std::cout << std::endl;
}
