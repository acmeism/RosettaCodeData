#include <cmath>
#include <cstdint>
#include <iostream>
#include <numeric>
#include <stdexcept>

class Rational {
public:
	/// Constructors ///
	Rational() : numer(0), denom(1) {}

	Rational(const int64_t number) : numer(number), denom(1) {}

	Rational(const int64_t& numerator, const int64_t& denominator) : numer(numerator), denom(denominator) {
		if ( numer == 0 ) {
			denom = 1;
		} else if ( denom == 0 ) {
		    throw std::invalid_argument("Denominator cannot be zero: " + denom);
		} else if ( denom < 0 ) {
			numer = -numer;
			denom = -denom;
		}

		int64_t divisor = std::gcd(numerator, denom);
		numer = numer / divisor;
		denom = denom / divisor;
	}

	Rational(const Rational& other) : numer(other.numer), denom(other.denom) {}

	/// Operators ///
	Rational& operator=(const Rational& other) {
	    if ( *this != other ) { numer = other.numer; denom = other.denom; }
	    return *this;
	}

	bool operator!=(const Rational& other) const { return ! ( *this == other ); }

	bool operator==(const Rational& other) const {
	    if ( numer == other.numer && denom == other.denom ) { return true; }
	    return false;
	}

	Rational& operator+=(const Rational& other) {
	    *this = Rational(numer* other.denom + other.numer * denom, denom * other.denom);
	    return *this;
	}

	Rational operator+(const Rational& other) const { return Rational(*this) += other; }

	Rational& operator-=(const Rational& other) {
	    Rational temp(other);
	    temp.numer = -temp.numer;
	    return *this += temp;
	}
	Rational operator-(const Rational& other) const { return Rational(*this) -= other; }

	Rational& operator*=(const Rational& other) {
	    *this = Rational(numer * other.numer, denom * other.denom);
	    return *this;
	}
	
	Rational operator*(const Rational& other) const { return Rational(*this) *= other; };

	Rational& operator/=(const Rational other) {
	    Rational temp(other.denom, other.numer);
	    *this *= temp;
	    return *this;
	}

	Rational operator/(const Rational& other) const { return Rational(*this) /= other; };

	bool operator<(const Rational& other) const { return numer * other.denom < denom * other.numer; }

	bool operator<=(const Rational& other) const { return ! ( other < *this ); }

	bool operator>(const Rational& other) const { return other < *this; }

	bool operator>=(const Rational& other) const { return ! ( *this < other ); }

	Rational operator-() const { return Rational(-numer, denom); }

	Rational& operator++() { numer += denom; return *this; }

	Rational operator++(int) { Rational temp = *this; ++*this; return temp; }

	Rational& operator--() { numer -= denom; return *this; }

	Rational operator--(int) { Rational temp = *this; --*this; return temp; }

	friend std::ostream& operator<<(std::ostream& outStream, const Rational& other) {
		outStream << other.numer << "/" << other.denom;
		return outStream;
	}

	/// Methods ///
	Rational reciprocal() const { return Rational(denom, numer); }

	Rational positive() const { return Rational(abs(numer), denom); }

	int64_t to_integer() const { return numer / denom; }

	double to_double() const { return (double) numer / denom; }

	int64_t hash() const { return std::hash<int64_t>{}(numer) ^ std::hash<int64_t>{}(denom); }
	
private:
	int64_t numer;
	int64_t denom;
};

int main() {
	std::cout << "Perfect numbers less than 2^19:" << std::endl;
	const int32_t limit = 1 << 19;
	for ( int32_t candidate = 2; candidate < limit; ++candidate ) {
		Rational sum = Rational(1, candidate);
		int32_t square_root = (int32_t) sqrt(candidate);
		for ( int32_t factor = 2; factor <= square_root; ++factor ) {
			if ( candidate % factor == 0 ) {
				sum += Rational(1, factor);
				sum += Rational(1, candidate / factor);
			}
		}

		if ( sum == Rational(1) ) {
			std::cout << candidate << std::endl;
		}
	}
}
