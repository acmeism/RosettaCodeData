#include <cstdint>
#include <iostream>
#include <vector>

struct Pair {
	uint64_t n;
	uint64_t p;
};

struct Solution {
	uint64_t root1;
	uint64_t root2;
	bool is_square;
};

uint64_t multiply_modulus(uint64_t a, uint64_t b, const uint64_t& modulus) {
    a %= modulus; b %= modulus;
    if ( b < a ) {
    	uint64_t temp = a; a = b; b = temp;
    }

    uint64_t result = 0;
    while ( a > 0 ) {
        if ( a % 2 == 1 ) {
        	result = ( result + b ) % modulus;
        };
        b = ( b << 1 ) % modulus;
        a >>= 1;
    }
    return result;
}

uint64_t power_modulus(uint64_t base, uint64_t exponent, const uint64_t& modulus) {
	if ( modulus == 1 ) {
		return 0;
	}

	base %= modulus;
	uint64_t result = 1;
	while ( exponent > 0 ) {
		if ( ( exponent & 1 ) == 1 ) {
			result = multiply_modulus(result, base, modulus);
		}
		base = multiply_modulus(base, base, modulus);
		exponent >>= 1;
	}
	return result;
}

uint64_t legendre(const uint64_t& a, const uint64_t& p) {
    return power_modulus(a, ( p - 1 ) / 2, p);
}

Solution tonelli_shanks(const uint64_t& n, const uint64_t& p) {
	if ( legendre(n, p) != 1 ) {
		return Solution(0, 0, false);
	}

	// Factor out powers of 2 from p - 1
    uint64_t q = p - 1;
    uint64_t s = 0;
    while ( q % 2 == 0 ) {
        q /= 2;
        s += 1;
    }

    if ( s == 1 ) {
	    uint64_t result = power_modulus(n, ( p + 1 ) / 4, p);
	    return Solution(result, p - result, true);
    }

    // Find a non-square z such as ( z | p ) = -1
    uint64_t z = 2;
	while ( legendre(z, p) != p - 1 ) {
		z += 1;
    }

    uint64_t c = power_modulus(z, q, p);
    uint64_t t = power_modulus(n, q, p);
    uint64_t m = s;
    uint64_t result = power_modulus(n, ( q + 1 ) >> 1, p);

    while ( t != 1 ) {
        uint64_t i = 1;
        z = multiply_modulus(t, t, p);
        while ( z != 1 && i < m - 1 ) {
            i += 1;
            z = multiply_modulus(z, z, p);
        }
        uint64_t b = power_modulus(c, 1 << ( m - i - 1 ), p);
        c = multiply_modulus(b, b, p);
        t = multiply_modulus(t, c, p);
        m = i;
        result = multiply_modulus(result, b, p);
    }
    return Solution(result, p - result, true);
}

int main() {
	const std::vector<Pair> tests = { Pair(10, 13), Pair(56, 101), Pair(1030, 1009), Pair(1032, 1009),
		Pair(44402, 100049), Pair(665820697, 1000000009), Pair(881398088036, 1000000000039) };

	for ( const Pair& test : tests ) {
		Solution solution = tonelli_shanks(test.n, test.p);
		std::cout << "n = " << test.n << ", p = " << test.p;
		if ( solution.is_square == true ) {
			std::cout << " has solutions: " << solution.root1 << " and " << solution.root2 << std::endl << std::endl;
		} else {
			std::cout << " has no solutions because n is not a square modulo p" << std::endl << std::endl;
		}
	}
}
