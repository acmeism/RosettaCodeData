#include <algorithm>
#include <complex>
#include <cstdint>
#include <iomanip>
#include <iostream>
#include <string>
#include <vector>

std::string to_string(const std::complex<int32_t>& complex_number) {
	std::string prefix = ( std::real(complex_number) < 0 ) ? "" : " ";
	std::string real_part = prefix + std::to_string(std::real(complex_number));
	std::string sign = ( std::imag(complex_number) < 0 ) ? " - " : " + ";
	const uint32_t imag_part = ( sign == " - " ) ? -std::imag(complex_number) : std::imag(complex_number);
	return real_part + sign + std::to_string(imag_part) + "i";
}

bool is_real_prime(const uint32_t& number) {
	if ( number < 2 ) { return false; }
	if ( number % 2 == 0 ) { return number == 2; }
	if ( number % 3 == 0 ) { return number == 3; }

	for ( uint32_t divisor = 5; divisor * divisor <= number; divisor += 2 ) {
		if ( number % divisor == 0 ) { return false; }
	}
	return true;
}

bool is_gaussian_prime(const std::complex<int32_t> complex_number) {
	int32_t r = std::real(complex_number); if ( r < 0 ) { r = -r; }
	int32_t c = std::imag(complex_number); if ( c < 0 ) { c = -c; }

	return is_real_prime(r * r + c * c)
		   || ( c == 0 && is_real_prime(r) && ( r - 3 ) % 4 == 0 )
		   || ( r == 0 && is_real_prime(c) && ( c - 3 ) % 4 == 0 );
}

int main() {
	const int32_t limit = 10;
	std::vector<std::complex<int32_t>> gaussian_primes = { };
	for ( int32_t real = -limit; real <= limit; ++real ) {
		for ( int32_t imag = -limit; imag <= limit; ++imag ) {
			const std::complex<int32_t> candidate(real, imag);
			if ( std::norm(candidate) < limit * limit && is_gaussian_prime(candidate) ) {
				gaussian_primes.emplace_back(candidate);
			}
		}
	}

	std::sort(gaussian_primes.begin(), gaussian_primes.end(),
		[](const auto& lhs, const auto& rhs) { return std::norm(lhs) < std::norm(rhs); });

	std::cout << "Gaussian primes less than radius 10 from the origin:" << "\n";
	for ( uint32_t i = 0; i < gaussian_primes.size(); ++i ) {
		std::cout << std::setw(8) << to_string(gaussian_primes[i]) << ( i % 10 == 9 ? "\n" : " " );
	}
}
