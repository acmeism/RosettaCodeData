#include <cmath>
#include <cstdint>
#include <iostream>
#include <numeric>
#include <stdexcept>
#include <string>
#include <vector>

class Rational {
public:
	Rational(const int32_t& aNumerator, const int32_t& aDenominator) {
		if ( aDenominator < 0 ) {
			numerator = -aNumerator;
			denominator = -aDenominator;
		} else {
			numerator = aNumerator;
			denominator = aDenominator;
		}

		if ( aNumerator == 0 ) {
			denominator = 1;
		}

		const uint32_t divisor = std::gcd(numerator, denominator);
		numerator /= divisor;
		denominator /= divisor;
	}

	std::string to_string() const {
		return std::to_string(numerator) + " / " + std::to_string(denominator);
	}

private:
	int32_t numerator;
	int32_t denominator;
};

class P_adic {
public:
	// Create a P_adic number, with p = 'prime', from the given rational 'numerator' / 'denominator'.
	P_adic(const uint32_t& prime, int32_t numerator, int32_t denominator) : prime(prime) {
		if ( denominator == 0 ) {
			throw std::invalid_argument("Denominator cannot be zero");
		}

		order = 0;

		// Process rational zero
		if ( numerator == 0 ) {
			digits.assign(DIGITS_SIZE, 0);
			order = ORDER_MAX;
			return;
		}

		// Remove multiples of 'prime' and adjust the order of the P_adic number accordingly
		while ( modulo_prime(numerator) == 0 ) {
			numerator /= static_cast<int32_t>(prime);
			order += 1;
		}

		while ( modulo_prime(denominator) == 0 ) {
			denominator /= static_cast<int32_t>(prime);
			order -= 1;
		}

		// Standard calculation of P_adic digits
		const uint64_t inverse = modulo_inverse(denominator);
		while ( digits.size() < DIGITS_SIZE ) {
			const uint32_t digit = modulo_prime(numerator * inverse);
			digits.emplace_back(digit);

			numerator -= digit * denominator;

			if ( numerator != 0 ) {
			// The denominator is not a power of a prime
				uint32_t count = 0;
				while ( modulo_prime(numerator) == 0 ) {
					numerator /= static_cast<int32_t>(prime);
					count += 1;
				}

				for ( uint32_t i = count; i > 1; --i ) {
					digits.emplace_back(0);
				}
			}
		}
	}

	// Return the sum of this P_adic number with the given P_adic number.
	P_adic add(P_adic other) {
		if ( prime != other.prime ) {
			throw std::invalid_argument("Cannot add p-adic's with different primes");
		}

		std::vector<uint32_t> this_digits = digits;
		std::vector<uint32_t> other_digits = other.digits;
		std::vector<uint32_t> result;

		// Adjust the digits so that the P_adic points are aligned
		for ( int32_t i = 0; i < -order + other.order; ++i ) {
			other_digits.insert(other_digits.begin(), 0);
		}

		for ( int32_t i = 0; i < -other.order + order; ++i ) {
			this_digits.insert(this_digits.begin(), 0);
		}

		// Standard digit by digit addition
		uint32_t carry = 0;
		for ( uint32_t i = 0; i < std::min(this_digits.size(), other_digits.size()); ++i ) {
			const uint32_t sum = this_digits[i] + other_digits[i] + carry;
			const uint32_t remainder = sum % prime;
			carry = ( sum >= prime ) ? 1 : 0;
			result.emplace_back(remainder);
		}

		return P_adic(prime, result, all_zero_digits(result) ? ORDER_MAX : std::min(order, other.order));
	}

	// Return the Rational representation of this P_adic number.
	Rational convert_to_rational() {
		std::vector<uint32_t> numbers = digits;

		// Zero
		if ( numbers.empty() || all_zero_digits(numbers) ) {
			return Rational(1, 0);
		}

		// Positive integer
		if ( order >= 0 && ends_with(numbers, 0) ) {
			for ( int32_t i = 0; i < order; ++i ) {
				numbers.emplace(numbers.begin(), 0);
			}

			return Rational(convert_to_decimal(numbers), 1);
		}

		// Negative integer
		if ( order >= 0 && ends_with(numbers, prime - 1) ) {
			negate_digits(numbers);
			for ( int32_t i = 0; i < order; ++i ) {
				numbers.emplace(numbers.begin(), 0);
			}

			return Rational(-convert_to_decimal(numbers), 1);
		}

		// Rational
		const P_adic copy(prime, digits, order);
		P_adic sum(prime, digits, order);
		int32_t denominator = 1;
		do {
			sum = sum.add(copy);
			denominator += 1;
		} while ( ! ( ends_with(sum.digits, 0) || ends_with(sum.digits, prime - 1) ) );

		const bool negative = ends_with(sum.digits, 6);
		if ( negative ) {
			negate_digits(sum.digits);
		}

		int32_t numerator = negative ? -convert_to_decimal(sum.digits) : convert_to_decimal(sum.digits);

		if ( order > 0 ) {
			numerator *= std::pow(prime, order);
		}

		if ( order < 0 ) {
			denominator *= std::pow(prime, -order);
		}

		return Rational(numerator, denominator);
	}

	// Return a string representation of this P_adic number.
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

		return " ..." + result.substr(result.length() - PRECISION - 1);
	}

private:
	/**
	 * Create a P_adic, with p = 'prime', directly from a vector of digits.
	 *
	 * For example: with 'order' = 0, the vector [1, 2, 3, 4, 5] creates the p-adic ...54321.0,
	 * 'order' > 0 shifts the vector 'order' places to the left and
	 * 'order' < 0 shifts the vector 'order' places to the right.
	 */
	P_adic(const uint32_t& prime, const std::vector<uint32_t>& digits, const int32_t& order)
		: prime(prime), digits(digits), order(order) {
	}

	// Transform the given vector of digits representing a P_adic number
	// into a vector which represents the negation of the P_adic number.
	void negate_digits(std::vector<uint32_t>& numbers) {
		numbers[0] = modulo_prime(prime - numbers[0]);
		for ( uint64_t i = 1; i < numbers.size(); ++i ) {
			numbers[i] = prime - 1 - numbers[i];
		}
	}

	// Return the multiplicative inverse of the given number modulo 'prime'.
	uint32_t modulo_inverse(const uint32_t& number) const {
		uint32_t inverse = 1;
		while ( modulo_prime(inverse * number) != 1 ) {
			inverse += 1;
		}
		return inverse;
	}

	// Return the given number modulo 'prime' in the range 0..'prime' - 1.
	int32_t modulo_prime(const int64_t& number) const {
		const int32_t div = static_cast<int32_t>(number % prime);
		return ( div >= 0 ) ? div : div + prime;
	}

	// The given vector is padded on the right by zeros up to a maximum length of 'DIGITS_SIZE'.
	void pad_with_zeros(std::vector<uint32_t>& vector) {
		while ( vector.size() < DIGITS_SIZE ) {
			vector.emplace_back(0);
		}
	}

	// Return the given vector of base 'prime' integers converted to a decimal integer.
	uint32_t convert_to_decimal(const std::vector<uint32_t>& numbers) const {
		uint32_t decimal = 0;
		uint32_t multiple = 1;
		for ( const uint32_t& number : numbers ) {
			decimal += number * multiple;
			multiple *= prime;
		}
		return decimal;
	}

	// Return whether the given vector consists of all zeros.
	bool all_zero_digits(const std::vector<uint32_t>& numbers) const {
		for ( uint32_t number : numbers ) {
			if ( number != 0 ) {
				return false;
			}
		}
		return true;
	}

	// Return whether the given vector ends with multiple instances of the given number.
	bool ends_with(const std::vector<uint32_t>& numbers, const uint32_t& number) const {
		for ( uint64_t i = numbers.size() - 1; i >= numbers.size() - PRECISION / 2; --i ) {
			if ( numbers[i] != number ) {
				return false;
			}
		}
		return true;
	}

	uint32_t prime;
	std::vector<uint32_t> digits;
	int32_t order;

	static const uint32_t PRECISION = 40;
	static const uint32_t ORDER_MAX = 1'000;
	static const uint32_t DIGITS_SIZE = PRECISION + 5;
};

int main() {
	std::cout << "3-adic numbers:" << std::endl;
	P_adic padic_one(3, -2, 87);
	std::cout << "-2 / 87    => " << padic_one.to_string() << std::endl;
	P_adic padic_two(3, 4, 97);
	std::cout << "4 / 97     => " << padic_two.to_string() << std::endl;

	P_adic sum = padic_one.add(padic_two);
	std::cout << "sum        => " << sum.to_string() << std::endl;
	std::cout << "Rational = " << sum.convert_to_rational().to_string() << std::endl;
	std::cout << std::endl;

	std::cout << "7-adic numbers:" << std::endl;
	padic_one = P_adic(7, 5, 8);
	std::cout << "5 / 8       => " << padic_one.to_string() << std::endl;
	padic_two = P_adic(7, 353, 30809);
	std::cout << "353 / 30809 => " << padic_two.to_string() << std::endl;

	sum = padic_one.add(padic_two);
	std::cout << "sum         => " << sum.to_string() << std::endl;
	std::cout << "Rational = " << sum.convert_to_rational().to_string() << std::endl;
	std::cout << std::endl;
}
