#include <algorithm>
#include <cmath>
#include <cstdint>
#include <iostream>
#include <random>

std::random_device random;
std::mt19937 generator(random());

// Return a random number within the range min..max, both inclusive
uint64_t range_random(const uint64_t& min, const uint64_t& max) {
	std::uniform_int_distribution<int32_t> distribution(min, max);
	return distribution(generator);
}

// Return a * b mod modulus
uint64_t multiply_modulus(const uint64_t& a, uint64_t b, const uint64_t& modulus) {
    uint64_t result = 0;
    uint64_t aa = a % modulus;

    while ( b > 0 ) {
        if ( ( b & 1 ) == 1 ) {
            result = ( result + aa ) % modulus;
        }
        aa = ( aa << 1 ) % modulus;
        b >>= 1;
    }

    return result;
}

// Return b^power mod modulus
uint64_t power_modulus(uint64_t base, uint64_t power, const uint64_t& modulus) {
	uint64_t result = 1;

	while ( power > 0 ) {
		if ( ( power & 1 ) == 1 ) {
			result = multiply_modulus(result, base, modulus);
		}
		base = multiply_modulus(base, base, modulus);
		power >>= 1;
	}
	return result;
}

// Helper function for the 'is_prime' function
bool is_witness(const uint64_t& a, const uint64_t& n) {
	uint64_t t = 0;
	uint64_t u = n - 1;
	while ( ( u & 1 ) == 0 ) {
		t = t + 1;
		u >>= 1;
	}

	uint64_t xx = power_modulus(a, u, n);
	for ( uint64_t i = 0; i < t; ++i ) {
		uint64_t yy = multiply_modulus(xx, xx, n);
		if ( yy == 1 && xx != 1 && xx != n - 1 ) {
			return true;
		}
		xx = yy;
	}

	return ( xx == 1 ) ? false : true;
}

// Uses the Miller-Rabin algorithm
bool is_prime(const uint64_t n) {
	if ( n <= 1 ) { return false; }
	const std::vector<uint64_t> primes = { 2, 3, 5, 7, 11, 13, 17 };
	if ( std::find(primes.begin(), primes.end(), n) != primes.end() ) { return true; }

	for ( const uint64_t& prime : primes ) {
		if ( is_witness(prime, n) ) {
			return false;
		}
	}
	return true;
}

int64_t legendre_symbol(const uint64_t& a, const uint64_t& p) {
    const uint64_t x = power_modulus(a, ( p - 1 ) / 2, p);

    if ( p - 1 == x ) {
        return x - p;
    }
    return x;
}

struct Fp2 {
	int64_t x, y;
};

Fp2 multiply_Fp2(const Fp2& a, const Fp2& b, const int64_t& prime, const int64_t& w2) {
	Fp2 result;

	uint64_t temp1 = multiply_modulus(a.x, b.x, prime);
	uint64_t temp2 = multiply_modulus(a.y, b.y, prime);
	temp2 = multiply_modulus(temp2, w2, prime);
	result.x = ( temp1 + temp2 ) % prime;
	temp1 = multiply_modulus(a.x, b.y, prime);
	temp2 = multiply_modulus(a.y, b.x, prime);
	result.y = ( temp1 + temp2 ) % prime;

	return result;
}

Fp2 power_Fp2(const Fp2& a, const int64_t& power, const int64_t& prime, const int64_t& w2) {
    Fp2 result;
    if ( power == 0 ) {
        result.x = 1;
        result.y = 0;
        return result;
    }
    if ( power == 1 ) {
        return a;
    }

    if ( ( power & 1 ) == 0 ) {
    	Fp2 temp = power_Fp2(a, power / 2, prime, w2);
        return multiply_Fp2(temp, temp, prime, w2);
    } else {
        return multiply_Fp2(a, power_Fp2(a, power - 1, prime, w2), prime, w2);
    }
}

void test(const uint64_t& n, const uint64_t& p) {
    std::cout << "Finding solutions for number = " << n << " and prime = " << p << ":" << std::endl;
    if ( p == 2 || ! is_prime(p) ) {
        std::cout << "No solutions, since p is not an odd prime." << std::endl << std::endl;
        return;
    }

    // p is a odd prime
    if ( legendre_symbol(n, p) != 1 ) {
        std::cout << "No solutions, since " << n << " is not a square in F" << p << std::endl << std::endl;
        return;
    }

    uint64_t a, w2;
    uint64_t x1, x2;
    Fp2 result;
    while ( true ) {
        do {
            a = range_random(2, p);
            w2 = a * a - n;
        } while ( legendre_symbol(w2, p) != -1 );

        result.x = a;
        result.y = 1;
        result = power_Fp2(result, ( p + 1 ) / 2, p, w2);
        if ( result.y != 0 ) {
            continue;
        }

        x1 = result.x;
        x2 = p - x1;
        if ( multiply_modulus(x1, x1, p) == n && multiply_modulus(x2, x2, p) == n ) {
        	std::cout << "Square roots of " << n << " are ( " << x1 << " and " << x2 << " ) mod "
        			  << p << std::endl << std::endl;
            return;
        }
    }
}

int main() {
	test(10, 13);
	test(56, 101);
	test(8'218, 10'007);
	test(8'219, 10'007);
	test(331'575, 1'000'003);
	test(665'165'880, 1'000'000'007);
    test(881'398'088'036, 1'000'000'000'039);
    test(12'345'678'901'234'567, 1'000'000'000'000'000'031);
}
