#include <cmath>
#include <cstdint>
#include <iostream>
#include <string>
#include <vector>

// Return the Sturmian word for the strictly positive rational number m / n
std::string sturmian_word_rational(const uint32_t& m, const uint32_t& n) {
	if ( m > n ) {
		const std::string inverse = sturmian_word_rational(n, m);
		std::string result;
		for ( const char& ch : inverse ) {
			result += ( ch == '0' ? "1" : "0" );
		}
		return result;
	}

	std::string sturmian;
	uint32_t k = 1;
	while ( ( k * m ) % n != 0 ) {
		const uint32_t previous_floor = ( k - 1 ) * m / n;
		const uint32_t current_floor = ( k * m ) / n;
		sturmian += ( previous_floor == current_floor ? "0" : "10" );
		k += 1;
	}
	return sturmian;
}

// Return the first 'letter_count' letters of Sturmian word for the strictly positive real number
// ( b * √(a) + m ) / n, where a is not a perfect square
std::string sturmian_word_quadratic(const int32_t& b, const uint32_t& a, const int32_t& m, const int32_t& n,
		                            const uint32_t& letter_count) {
	std::vector<uint32_t> p = { 0, 1 };
	std::vector<uint32_t> q = { 1, 0 };
	double remainder = ( b * std::sqrt(a) + m ) / n;

	for ( uint32_t i = 1; i <= letter_count; ++i ) {
		const int32_t integer_part = static_cast<uint32_t>(remainder);
		const double fraction_part  = remainder - integer_part;
		const int32_t pn = integer_part * p.back() + p[p.size() - 2];
		const int32_t qn = integer_part * q.back() + q[q.size() - 2];
		p.emplace_back(pn);
		q.emplace_back(qn);
		remainder = 1.0 / fraction_part;
	};
	return sturmian_word_rational(p.back(), q.back());
}

// Return the Fibonacci word for the given integer
// For more information visit https://en.wikipedia.org/wiki/Fibonacci_word
std::string fibonacci_word(const uint32_t& number) {
	std::string previous = "0";
	std::string result = "01";
	for ( uint32_t i = 2; i < number; ++i ) {
		std::string temp = result;
		result += previous;
		previous = temp;
	}
	return result;
}

int main() {
	const std::string sturmian = sturmian_word_rational(13, 21);
	std::cout << sturmian << " from rational number 13 / 21" << std::endl;

	std::cout << sturmian_word_quadratic(1, 5, -1, 2, 8)
			  << " from real number ( √5 - 1 ) / 2, the first 8 letters" << std::endl;

	std::string fibonacci = fibonacci_word(10);
	std::cout << "Sturmian word equals Fibonacci word? : " << std::boolalpha
		      << ( sturmian == fibonacci.substr(0, sturmian.length()) ) << std::endl;
}
