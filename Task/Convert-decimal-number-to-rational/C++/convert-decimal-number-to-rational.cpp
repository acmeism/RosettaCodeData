#include <cmath>
#include <cstdint>
#include <iostream>
#include <limits>
#include <numeric>
#include <vector>

class Rational {
public:
	Rational(const int64_t& numer, const uint64_t& denom) : numerator(numer), denominator(denom) { }

	Rational negate() {
		return Rational(-numerator, denominator);
	}

	std::string to_string() {
		return std::to_string(numerator) + " / " + std::to_string(denominator);
	}

private:
	int64_t numerator;
	uint64_t denominator;
};
/**
 * Return a Rational such that its numerator / denominator = 'decimal', correct to dp decimal places,
 * where dp is minimum of 'decimal_places' and the number of decimal places in 'decimal'.
 */
Rational decimal_to_rational(double decimal, const uint32_t& decimal_places) {
	const double epsilon = 1.0 / std::pow(10, decimal_places);

	const bool negative = ( decimal < 0.0 );
	if ( negative ) {
		decimal = -decimal;
	}

	if ( decimal < std::numeric_limits<double>::min() ) {
		return Rational(0, 1);
	}

	if ( std::abs( decimal - std::round(decimal) ) < epsilon )  {
		return Rational(std::round(decimal), 1);
	}

	uint64_t a = 0;
	uint64_t b = 1;
	uint64_t c = static_cast<uint64_t>(std::ceil(decimal));
	uint64_t d = 1;
	const uint64_t auxiliary_1 = std::numeric_limits<uint64_t>::max() / 2;

	while ( c < auxiliary_1 && d < auxiliary_1 ) {
		const double auxiliary_2 = static_cast<double>( a + c ) / ( b + d );

		if ( std::abs(decimal - auxiliary_2) < epsilon ) {
			break;
		}

		if ( decimal > auxiliary_2 ) {
			a = a + c;
			b = b + d;
		} else {
			c = a + c;
			d = b + d;
		}
	}

	const uint64_t divisor = std::gcd(( a + c ), ( b + d ));
	Rational result(( a + c ) / divisor, ( b + d ) / divisor);
	return ( negative ) ? result.negate() : result;
}

int main() {
	for ( const double& decimal : { 3.1415926535, 0.518518, -0.75, 0.518518518518, -0.9054054054054, -0.0, 2.0 } ) {
		std::cout << decimal_to_rational(decimal, 9).to_string() << std::endl;
	}
}
