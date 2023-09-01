#include <cstdint>
#include <iomanip>
#include <iostream>
#include <random>
#include <stdexcept>
#include <string>
#include <vector>

const int32_t MAX_MODULUS = 1073741789;
const int32_t MAX_ORDER_G = MAX_MODULUS + 65536;

std::random_device random;
std::mt19937 generator(random());
std::uniform_real_distribution<double> distribution(0.0F, 1.0F);

class Point {
public:
	Point(const int64_t& x, const int64_t& y) : x(x), y(y) {}

	Point() : x(0),y(0) {}

	bool isZero() {
		return x == INT64_MAX && y == 0;
	}

	int64_t x, y;
};

const Point ZERO_POINT(INT64_MAX, 0);

class Pair {
public:
	Pair(const int64_t& a, const int64_t& b) : a(a), b(b) {}

	const int64_t a, b;
};

class Parameter {
public:
	Parameter(const int64_t& a, const int64_t& b, const int64_t& n, const Point& g, const int64_t& r)
	: a(a), b(b), n(n), g(g), r(r) {}

	const int64_t a, b, n;
	const Point g;
	const int64_t r;
};

int64_t signum(const int64_t& x) {
	return ( x < 0 ) ? -1 : ( x > 0 ) ? 1 : 0;
}

int64_t floor_mod(const int64_t& num, const int64_t& mod) {
	const int64_t signs = ( signum(num % mod) == -signum(mod) ) ? 1 : 0;
	return ( num % mod ) + signs * mod;
}

int64_t floor_div(const int64_t& number, const int64_t& modulus) {
	const int32_t signs = ( signum(number % modulus) == -signum(modulus) ) ? 1 : 0;
	return ( number / modulus ) - signs;
}

// Return 1 / aV modulus aU
int64_t extended_GCD(int64_t v, int64_t u) {
	if ( v < 0 ) {
		v += u;
	}

	int64_t result = 0;
	int64_t s = 1;
	while ( v != 0 ) {
		const int64_t quotient = floor_div(u, v);
		u = floor_mod(u, v);
		std::swap(u, v);
		result -= quotient * s;
		std::swap(result, s);
	}

	if ( u != 1 ) {
		throw std::runtime_error("Cannot inverse modulo N, gcd = " + u);
	}
	return result;
}

class Elliptic_Curve {
public:
	Elliptic_Curve(const Parameter& parameter) {
		n = parameter.n;
		if ( n < 5 || n > MAX_MODULUS ) {
			throw std::invalid_argument("Invalid value for modulus: " + n);
		}

		a = floor_mod(parameter.a, n);
		b = floor_mod(parameter.b, n);
		g = parameter.g;
		r = parameter.r;

		if ( r < 5 || r > MAX_ORDER_G ) {
			throw std::invalid_argument("Invalid value for the order of g: " + r);
		}

		std::cout << std::endl;
		std::cout << "Elliptic curve: y^2 = x^3 + " << a << "x + " << b << " (mod " << n << ")" << std::endl;
		print_point_with_prefix(g, "base point G");
		std::cout << "order(G, E) = " << r << std::endl;
	}

	Point add(Point p, Point q) {
		if ( p.isZero() ) {
			return q;
		}
		if ( q.isZero() ) {
			return p;
		}

		int64_t la;
		if ( p.x != q.x ) {
			la = floor_mod(( p.y - q.y ) * extended_GCD(p.x - q.x, n), n);
		} else if ( p.y == q.y && p.y != 0 ) {
			la = floor_mod(floor_mod(floor_mod(p.x * p.x, n) * 3 + a, n) * extended_GCD(2 * p.y, n), n);
		} else {
			return ZERO_POINT;
		}

		const int64_t x_coord = floor_mod(la * la - p.x - q.x, n);
		const int64_t y_coord = floor_mod(la * ( p.x - x_coord ) - p.y, n);
		return Point(x_coord, y_coord);
	}

	Point multiply(Point point, int64_t k) {
		Point result = ZERO_POINT;

		while ( k != 0 ) {
			if ( ( k & 1 ) == 1 ) {
				result = add(result, point);
			}
			point = add(point, point);
			k >>= 1;
		}
		return result;
	}

	bool contains(Point point) {
		if ( point.isZero() ) {
			return true;
		}

		int64_t r = floor_mod(floor_mod(a + point.x * point.x, n) * point.x + b, n);
		int64_t s = floor_mod(point.y * point.y, n);
		return r == s;
	}

	uint64_t discriminant() {
		const int64_t constant = 4 * floor_mod(a * a, n) * floor_mod(a, n);
		return floor_mod(-16 * ( floor_mod(b * b, n) * 27 + constant ), n);
	}

	void print_point_with_prefix(Point point, const std::string& prefix) {
		int64_t y = point.y;
		if ( point.isZero() ) {
			std::cout << prefix + " (0)" << std::endl;
		} else {
			if ( y > n - y ) {
				y -= n;
			}
			std::cout << prefix + " (" << point.x << ", " << y << ")" << std::endl;
		}
	}

	int64_t a, b, n, r;
	Point g;
};

double random_number() {
	return distribution(generator);
}

Pair signature(Elliptic_Curve curve, const int64_t& s, const int64_t& f) {
	int64_t c, d, u;
	Point v;

	while ( true ) {
		while ( true ) {
			u = 1 + (int64_t) ( random_number() * (double) ( curve.r - 1 ) );
			v = curve.multiply(curve.g, u);
			c = floor_mod(v.x, curve.r);
			if ( c != 0 ) {
				break;
			}
		}

		d = floor_mod(extended_GCD(u, curve.r) * floor_mod(f + s * c, curve.r), curve.r);
		if ( d != 0 ) {
			break;
		}
	}

	std::cout << "one-time u = " << u << std::endl;
	curve.print_point_with_prefix(v, "V = uG");
	return Pair(c, d);
}

bool verify(Elliptic_Curve curve, Point point, const int64_t& f, const Pair& signature) {
	if ( signature.a < 1 || signature.a >= curve.r || signature.b < 1 || signature.b >= curve.r ) {
		return false;
	}

	std::cout << "\n" << "signature verification" << std::endl;
	const int64_t h = extended_GCD(signature.b, curve.r);
	const int64_t h1 = floor_mod(f * h, curve.r);
	const int64_t h2 = floor_mod(signature.a * h, curve.r);
	std::cout << "h1, h2 = " << h1 << ", " << h2 << std::endl;
	Point v = curve.multiply(curve.g, h1);
	Point v2 = curve.multiply(point, h2);
	curve.print_point_with_prefix(v, "h1G");
	curve.print_point_with_prefix(v2, "h2W");
	v = curve.add(v, v2);
	curve.print_point_with_prefix(v, "+ =");

	if ( v.isZero() ) {
		return false;
	}
	int64_t c1 = floor_mod(v.x, curve.r);
	std::cout << "c' = " << c1 << std::endl;
	return c1 == signature.a;
}

// Build the digital signature for a message using the hash aF with error bit aD
void ecdsa(Elliptic_Curve curve, int64_t f, int32_t d) {
	Point point = curve.multiply(curve.g, curve.r);

	if ( curve.discriminant() == 0 || curve.g.isZero() || ! point.isZero() || ! curve.contains(curve.g) ) {
		throw std::invalid_argument("Invalid parameter in the method ecdsa");
	}

	std::cout << "\n" << "key generation" << std::endl;
	const int64_t s = 1 + (int64_t) ( random_number() * (double) ( curve.r - 1 ) );
	point = curve.multiply(curve.g, s);
	std::cout << "private key s = " << s << std::endl;
	curve.print_point_with_prefix(point, "public key W = sG");

	// Find the next highest power of two minus one.
	int64_t t = curve.r;
	int64_t i = 1;
	while ( i < 64 ) {
		t |= t >> i;
		i <<= 1;
	}
	while ( f > t ) {
		f >>= 1;
	}
	std::cout << "\n" << "aligned hash " << std::hex << std::setfill('0') << std::setw(8) << f
			  << std::dec << std::endl;

	const Pair signature_pair = signature(curve, s, f);
	std::cout << "signature c, d = " << signature_pair.a << ", " << signature_pair.b << std::endl;

	if ( d > 0 ) {
		while ( d > t ) {
			d >>= 1;
		}
		f ^= d;
		std::cout << "\n" << "corrupted hash " << std::hex << std::setfill('0') << std::setw(8) << f
                  << std::dec << std::endl;
	}

	std::cout << ( verify(curve, point, f, signature_pair) ? "Valid" : "Invalid" ) << std::endl;
	std::cout << "-----------------" << std::endl;
}

int main() {
	// Test parameters for elliptic curve digital signature algorithm,
	// using the short Weierstrass model: y^2 = x^3 + ax + b (mod N).
	//
	// Parameter: a, b, modulus N, base point G, order of G in the elliptic curve.

	const std::vector<Parameter> parameters {
		Parameter( 355, 671, 1073741789, Point(13693, 10088), 1073807281 ),
		Parameter(   0,   7,   67096021, Point( 6580,   779),   16769911 ),
		Parameter(  -3,   1,     877073, Point(    0,     1),     878159 ),
		Parameter(   0,  14,      22651, Point(   63,    30),        151 ),
		Parameter(   3,   2,          5, Point(    2,     1),          5 ) };

		// Parameters which cause failure of the algorithm for the given reasons
		// the base point is of composite order
//		Parameter(   0,   7,   67096021, Point( 2402,  6067),   33539822 ),
		// the given order is of composite order
//		Parameter(   0,   7,   67096021, Point( 6580,   779),   67079644 ),
		// the modulus is not prime (deceptive example)
//		Parameter(   0,   7,     877069, Point(    3, 97123),     877069 ),
		// fails if the modulus divides the discriminant
//		Parameter(  39, 387,      22651, Point(   95,    27),      22651 ) );

	const int64_t f = 0x789abcde; // The message's digital signature hash which is to be verified
	const int32_t d = 0;           // Set d > 0 to simulate corrupted data

	for ( const Parameter& parameter : parameters ) {
		Elliptic_Curve elliptic_curve(parameter);
		ecdsa(elliptic_curve, f, d);
	}
}
