#include <cmath>
#include <cstdint>
#include <iostream>
#include <numeric>
#include <string>
#include <vector>

class Rational {
public:
	Rational(const uint64_t& aNumerator, const uint64_t& aDenominator)
		: numerator(aNumerator), denominator(aDenominator) {
    	const uint64_t gcd = std::gcd(numerator, denominator);
    	numerator /= gcd;
    	denominator /= gcd;
    }

	Rational(const uint64_t& value) : numerator(value), denominator(1) { }

	Rational(const std::string& decimal) {
		const std::string::size_type index = decimal.find(".");
		const uint32_t decimal_places = decimal.length() - 1 - index;
		const uint64_t numer =
			std::stoll(decimal.substr(0, index) + decimal.substr(index + 1, decimal.size()));
		const uint64_t denom = std::pow(10, decimal_places);
		const uint64_t gcd = std::gcd(numer, denom);
		numerator = numer / gcd;
		denominator = denom / gcd;
	}

	std::string to_decimal(const uint32_t& decimal_places) const {
		std::string result = "";
		uint64_t numer = numerator;
		uint64_t denom = denominator;
		uint64_t quotient = numer / denom;
		for ( uint32_t i = 0; i <= decimal_places; ++i ) {
			result += std::to_string(quotient);
			numer -= denom * quotient;
			if ( numer == 0 ) {
				break;
			}
			numer *= 10;
			quotient = numer / denom;
			if ( i == 0 ) {
				result += ".";
			}
		}
		return result;
	}

	bool equals(const Rational& other) const {
		return numerator == other.numerator && denominator == other.denominator;
	}

	Rational add(const Rational& other) const {
		const uint64_t numer = ( numerator * other.denominator ) + ( denominator * other.numerator );
		const uint64_t denom = denominator * other.denominator;
		return Rational(numer, denom);
	}

	Rational subtract(const Rational& other) const {
		const uint64_t numer = ( numerator * other.denominator ) - ( denominator * other.numerator );
		const uint64_t denom = denominator * other.denominator;
		return Rational(numer, denom);
	}

	Rational multiply(const Rational& other) const {
		return Rational(numerator * other.numerator, denominator * other.denominator);
	}

	Rational inverse() const {
		return Rational(denominator, numerator);
	}

	int64_t ceiling() const {
		return ( numerator % denominator == 0 ) ? numerator / denominator : numerator / denominator + 1;
	}

private:
	uint64_t numerator, denominator;
};

const Rational RATIONAL_ZERO(0, 1);
const Rational RATIONAL_ONE(1, 1);

std::vector<uint64_t> to_engel(const std::string& decimal) {
	std::vector<uint64_t> engel = { };
	Rational rational(decimal);
	while ( ! rational.equals(RATIONAL_ZERO) ) {
		const int64_t term = rational.inverse().ceiling();
		engel.emplace_back(term);
		rational = rational.multiply(Rational(term)).subtract(RATIONAL_ONE);
	}
	return engel;
}

Rational from_engel(const std::vector<uint64_t>& engel) {
	Rational sum = RATIONAL_ZERO;
	Rational product = RATIONAL_ONE;
	for ( const uint64_t& element : engel ) {
		Rational rational = Rational(element).inverse();
		product = product.multiply(rational);
		sum = sum.add(product);
	}
	return sum;
}

int main() {
	std::vector<std::string> rationals = { "3.14159265358979", "2.71828182845904", "1.414213562373095" };

	for ( const std::string& rational : rationals ) {
		std::vector<uint64_t> engel = to_engel(rational);
		std::cout << "Rational number : " << rational << "\n";
		std::cout << "Engel expansion : ";
		for ( const uint64_t& element : engel ) {
			std::cout << element << " ";
		}
		std::cout << "\n";
		std::cout << "Number of terms : " << engel.size() << "\n";

		// Due to integer overflow,
		// C++ can only reconstruct the decimal numbers to a limted number of decimal places.

		const uint64_t decimal_places = rational.length() - rational.find(".");
		std::vector<uint64_t> reduced_engel = { engel.begin(), engel.begin() + 9 };
		std::cout << "Back to rational: "
				  << from_engel(reduced_engel).to_decimal(decimal_places / 2) << "\n";
		std::cout << "\n";
	}
}
