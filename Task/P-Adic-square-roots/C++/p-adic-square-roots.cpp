#include <algorithm>
#include <cmath>
#include <cstdint>
#include <iostream>
#include <stdexcept>
#include <vector>

class P_adic_square_root {
public:
	// Create a P_adic_square_root number, with p = 'prime', from the given rational 'numerator' / 'denominator'.
	P_adic_square_root(const uint32_t& prime, const uint32_t& precision, int32_t numerator, int32_t denominator)
	: prime(prime), precision(precision) {

		if ( denominator == 0 ) {
			throw std::invalid_argument("Denominator cannot be zero");
		}

		order = 0;

		// Process rational zero
		if ( numerator == 0 ) {
			digits.assign(digits_size, 0);
			order = ORDER_MAX;
			return;
		}

		// Remove multiples of 'prime' and adjust the order of the P_adic_square_root number accordingly
		while ( modulo(numerator, prime) == 0 ) {
			numerator /= static_cast<int32_t>(prime);
			order += 1;
		}

		while ( modulo(denominator, prime) == 0 ) {
			denominator /= static_cast<int32_t>(prime);
			order -= 1;
		}

		if ( ( order & 1 ) != 0 ) {
			throw std::invalid_argument("Number does not have a square root in " + std::to_string(prime) + "-adic");
		}
		order >>= 1;

		if ( prime == 2 ) {
			square_root_even_prime(numerator, denominator);
		} else {
			square_root_odd_prime(numerator, denominator);
		}
	}

	// Return the additive inverse of this P_adic_square_root number.
	P_adic_square_root negate() {
		if ( digits.empty() ) {
			return *this;
		}

		std::vector<uint32_t> negated = digits;
		negate_digits(negated);

		return P_adic_square_root(prime, precision, negated, order);
	}

	// Return the product of this P_adic_square_root number and the given P_adic_square_root number.
	P_adic_square_root multiply(P_adic_square_root other) {
		if ( prime != other.prime ) {
			throw std::invalid_argument("Cannot multiply p-adic's with different primes");
		}

		if ( digits.empty() || other.digits.empty() ) {
			return P_adic_square_root(prime, precision, 0 , 1);
		}

		return P_adic_square_root(prime, precision, multiply(digits, other.digits), order + other.order);
	}

	// Return a string representation of this P_adic_square_root as a rational number.
	std::string convertToRational() {
		std::vector<uint32_t> numbers = digits;

		if ( numbers.empty() ) {
			return "0 / 1";
		}

		// Lagrange lattice basis reduction in two dimensions
		int64_t series_sum = numbers.front();
		int64_t maximum_prime = 1;

		for ( uint32_t i = 1; i < precision; ++i ) {
			maximum_prime *= prime;
			series_sum += numbers[i] * maximum_prime;
		}

		std::vector<int64_t> one = { maximum_prime, series_sum };
		std::vector<int64_t> two = { 0, 1 };

		int64_t previous_norm = series_sum * series_sum + 1;
		int64_t current_norm = previous_norm + 1;
		uint32_t i = 0;
		uint32_t j = 1;

		while ( previous_norm < current_norm ) {
			int64_t numerator = one[i] * one[j] + two[i] * two[j];
			int64_t denominator = previous_norm;
			current_norm = std::floor(static_cast<double>(numerator) / denominator + 0.5);
			one[i] -= current_norm * one[j];
			two[i] -= current_norm * two[j];

			current_norm = previous_norm;
			previous_norm = one[i] * one[i] + two[i] * two[i];

			if ( previous_norm < current_norm ) {
				std::swap(i, j);
			}
		}

		int64_t x = one[j];
		int64_t y = two[j];
		if ( y < 0 ) {
			y = -y;
			x = -x;
		}

		if ( std::abs(one[i] * y - x * two[i]) != maximum_prime ) {
			throw std::invalid_argument("Rational reconstruction failed.");
		}

		for ( int32_t k = order; k < 0; ++k ) {
			y *= prime;
		}

		for ( int32_t k = order; k > 0; --k ) {
			x *= prime;
		}

		return std::to_string(x) + " / " + std::to_string(y);
	}

	// Return a string representation of this P_adic_square_root.
	std::string to_string() {
		std::vector<uint32_t> numbers = digits;
		pad_with_zeros(numbers);

		std::string result = "";
		for ( int64_t i = numbers.size() - 1; i >= 0; --i ) {
			result += std::to_string(digits[i]);
		}

		if ( order >= 0 ) {
			for ( int32_t i = 0; i < order; ++i ) {
				result += "0";
			}

			result += ".0";
		} else {
			result.insert(result.length() + order, ".");

			while ( result[result.length() - 1] == '0' ) {
				result = result.substr(0, result.length() - 1);
			}
		}

		return " ..." + result.substr(result.length() - precision - 1);
	}

private:
	/**
	 * Create a P_adic_square_root, with p = 'prime', directly from a vector of digits.
	 *
	 * For example: with 'order' = 0, the vector [1, 2, 3, 4, 5] creates the P_adic_square_root ...54321.0,
	 * 'order' > 0 shifts the vector 'order' places to the left and
	 * 'order' < 0 shifts the vector 'order' places to the right.
	 */
	P_adic_square_root(
        const uint32_t& prime, const uint32_t& precision, const std::vector<uint32_t>& digits, const int32_t& order)
		: prime(prime), precision(precision), digits(digits), order(order) {
	}

	// Create a 2-adic number which is the square root of the rational 'numerator' / 'denominator'.
	void square_root_even_prime(const int32_t& numerator, const int32_t& denominator) {
		if ( modulo(numerator * denominator, 8) != 1 ) {
			throw std::invalid_argument("Number does not have a square root in 2-adic");
		}

		// First digit
		uint64_t sum = 1;
		digits.emplace_back(sum);

		// Further digits
		while ( digits.size() < digits_size ) {
			int64_t factor = denominator * sum * sum - numerator;
			uint32_t valuation = 0;
			while ( modulo(factor, 2) == 0 ) {
				factor /= 2;
				valuation += 1;
			}

			sum += std::pow(2, valuation - 1);

			for ( uint32_t i = digits.size(); i < valuation - 1; ++i ) {
				digits.emplace_back(0);
			}
			digits.emplace_back(1);
		}
	}

	// Create a p-adic number, with an odd prime number, p = 'prime',
	// which is the p-adic square root of the given rational 'numerator' / 'denominator'.
	void square_root_odd_prime(const int32_t& numerator, const int32_t& denominator) {
		// First digit
		int32_t first_digit = 0;
		for ( int32_t i = 1; i < prime && first_digit == 0; ++i ) {
			if ( modulo(denominator * i * i - numerator, prime) == 0 ) {
				first_digit = i;
			}
		}

		if ( first_digit == 0 ) {
			throw std::invalid_argument("Number does not have a square root in " + std::to_string(prime) + "-adic");
		}

		digits.emplace_back(first_digit);

		// Further digits
		const uint64_t coefficient = modulo_inverse(modulo(2 * denominator * first_digit, prime));
		uint64_t sum = first_digit;
		for ( uint32_t i = 2; i < digits_size; ++i ) {
			int64_t next_sum = sum - ( coefficient * ( denominator * sum * sum - numerator ) );
			next_sum = modulo(next_sum, static_cast<uint64_t>(std::pow(prime, i)));
			next_sum -= sum;
			sum += next_sum;

			const uint32_t digit = next_sum / std::pow(prime, i - 1);
			digits.emplace_back(digit);
		}
	}

	// Return the list obtained by multiplying the digits of the given two lists,
	// where the digits in each list are regarded as forming a single number in reverse.
	// For example 12 * 13 = 156 is computed as [2, 1] * [3, 1] = [6, 5, 1].
	std::vector<uint32_t> multiply(const std::vector<uint32_t>& one, const std::vector<uint32_t>& two) {
		std::vector<uint32_t> product(one.size() + two.size(), 0);
		for ( uint32_t b = 0; b < two.size(); ++b ) {
			uint32_t carry = 0;
			for ( uint32_t a = 0; a < one.size(); ++a ) {
				product[a + b] += one[a] * two[b] + carry;
				carry = product[a + b] / prime;
				product[a + b] %= prime;
			}
			product[b + one.size()] = carry;
		}

		return std::vector(product.begin(), product.begin() + digits_size);
	}

	// Return the multiplicative inverse of the given number modulo 'prime'.
	uint32_t modulo_inverse(const uint32_t& number) const {
		uint32_t inverse = 1;
		while ( modulo(inverse * number, prime) != 1 ) {
			inverse += 1;
		}
		return inverse;
	}

	// Return the given number modulo 'prime' in the range 0..'prime' - 1.
	int32_t modulo(const int64_t& number, const int64_t& modulus) const {
		const int32_t div = static_cast<int32_t>(number % modulus);
		return ( div >= 0 ) ? div : div + modulus;
	}

	// Transform the given vector of digits representing a p-adic number
	// into a vector which represents the negation of the p-adic number.
	void negate_digits(std::vector<uint32_t>& numbers) {
		numbers[0] = modulo(prime - numbers[0], prime);
		for ( uint64_t i = 1; i < numbers.size(); ++i ) {
			numbers[i] = prime - 1 - numbers[i];
		}
	}

	// The given vector is padded on the right by zeros up to a maximum length of 'DIGITS_SIZE'.
	void pad_with_zeros(std::vector<uint32_t>& vector) {
		while ( vector.size() < digits_size ) {
			vector.emplace_back(0);
		}
	}

	const int32_t prime;
	const uint32_t precision;
	const uint32_t digits_size = precision + 5;

	std::vector<uint32_t> digits;
	int32_t order;

	static const uint32_t ORDER_MAX = 1'000;
};

int main() {
	std::vector<std::vector<int32_t>> tests = { { 2, 20, 497, 10496 }, { 5, 14, 86, 25 }, { 7, 10, -19, 1 } };

	for ( const std::vector<int32_t>& test : tests ) {
		std::cout << "Number: " << test[2] << " / " << test[3] << " in " << test[0] << "-adic" << std::endl;
		P_adic_square_root square_root(test[0], test[1], test[2], test[3]);
		std::cout << "The two square roots are:" << std::endl;
		std::cout << "    " << square_root.to_string() << std::endl;
		std::cout << "    " << square_root.negate().to_string() << std::endl;
		P_adic_square_root square = square_root.multiply(square_root);
		std::cout << "The p-adic value is " << square.to_string() << std::endl;
		std::cout << "The rational value is " << square.convertToRational() << std::endl;
		std::cout << std::endl;
	}
}
