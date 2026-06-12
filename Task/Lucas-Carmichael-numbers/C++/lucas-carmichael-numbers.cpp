#include <cmath>
#include <cstdint>
#include <iomanip>
#include <iostream>
#include <numeric>
#include <vector>

bool is_prime(const uint64_t& number) {
	if ( number % 2 == 0 ) {
		return number == 2;
	}

	uint64_t k = 3;
	while ( k * k <= number ) {
		if ( number % k == 0 ) {
			return false;
		}
		k += 2;
	}

	return true;
}

uint64_t primorial(const uint32_t& n) {
	uint64_t result = 1;
	for ( uint32_t i = 2; i <= n; ++i ) {
		if ( is_prime(i) ) {
			result *= i;
		}
	}

	return result;
}

uint64_t lcm(const uint64_t& r, const uint64_t& s) {
	return ( r * s ) / std::gcd(r, s);
}

uint64_t modular_inverse(uint64_t a, uint64_t m) {
	if ( m == 1 ) {
		return 0;
	}

	uint64_t m0 = m;
	int64_t x0 = 0;
	int64_t x1 = 1;

	while ( a > 1 ) {
		int64_t quotient = a / m;
		int64_t temp = m;
		m = a % m;
		a = temp;
		temp = x0;
		x0 = x1 - quotient * x0;
		x1 = temp;
	}

	if ( x1 < 0 ) {
		x1 += m0;
	}

	return x1;
}

void process_level(const uint64_t& m, const uint64_t& L, uint64_t lo,
		           const uint64_t& A, const uint64_t& B, const uint64_t& k, const uint64_t& max_p,
			       std::vector<uint64_t>& numbers_LC) {

	uint64_t hi = std::round(std::pow(B / m, 1.0 / k));
	if ( lo > hi ) {
		return;
	}

	if ( k == 1 ) {
		hi = std::min(max_p, hi);
		lo = std::max(static_cast<uint64_t>(std::ceil(A / m)), lo);
		if ( lo > hi ) {
			return;
		}

		uint64_t temp = L - modular_inverse(m, L);
		while ( temp < lo ) {
			temp += L;
		}

		for ( uint64_t p = temp; p <= hi; p += L ) {
			if ( is_prime(p) ) {
				const uint64_t n = m * p;
				if ( ( n + 1 ) % ( p + 1 ) == 0 ) {
					numbers_LC.emplace_back(n);
				}
			}
		}
	} else {
		for ( uint64_t p = lo; p <= hi; ++p ) {
			if ( is_prime(p) && std::gcd(m, p + 1) == 1 ) {
				process_level(m * p, lcm(L, p + 1), p + 1, A, B, k - 1, max_p, numbers_LC);
			}
		}
	}
}

void LC_in_range(uint64_t A, const uint64_t& B, const uint32_t& k, std::vector<uint64_t>& numbers_LC) {
	const uint64_t max_p = std::sqrt(B + 1) - 1;
	A = std::max(primorial(k + 1) / 2, A);
	process_level(1, 1, 3, A, B, k, max_p, numbers_LC);
}

uint32_t LC_count(const uint64_t& A, const uint64_t& B) {
	std::vector<uint64_t> numbers_LC;
	uint32_t k = 3;

	while ( k <= 8 ) {
		if ( primorial(k + 1) / 2 > B ) {
			break;
		}

		LC_in_range(A, B, k, numbers_LC);
		k++;
	}

	return numbers_LC.size();
}

uint64_t lucas_carmichael_with_n_primes(const uint32_t& n) {
	 if ( n < 3 ) {
		 return 0;
	 }

	uint64_t x = primorial(( n + 1 ) / 2);
	uint64_t y = 2 * x;
	uint64_t min_LC = 0;

	while ( true ) {
		std::vector<uint64_t> numbers_LC;
		LC_in_range(x, y, n, numbers_LC);

		for ( const uint64_t& number : numbers_LC ) {
			if ( min_LC == 0 || min_LC > number ) {
				min_LC = number;
			}
		}

		if ( min_LC > 0 ) {
			return min_LC;
		}

		x = y + 1;
		y = 2 * x;
	}
}

int main() {
	std::cout << "Least Lucas-Carmichael number with n prime factors:" << std::endl;
	for ( uint32_t n = 3; n <= 12; ++n ) {
		std::cout << std::setw(2) << n << ":" << std::setw(21) << lucas_carmichael_with_n_primes(n) << std::endl;
	}

	std::cout << "\nNumber of Lucas-Carmichael numbers less than 10^n:" << std::endl;
	uint32_t accumulator = 0;
	for ( uint32_t n = 1; n <= 10; ++n ) {
		accumulator += LC_count(std::pow(10, n - 1), std::pow(10, n));
		std::cout << std::setw(2) << n << ":" << std::setw(5) << accumulator << std::endl;
	}
}
