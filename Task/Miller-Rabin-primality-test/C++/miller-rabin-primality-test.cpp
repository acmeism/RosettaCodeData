#include <algorithm>
#include <cmath>
#include <cstdint>
#include <iostream>
#include <vector>

std::vector<uint32_t> small_primes{ 2, 3 };

uint64_t add_modulus(const uint64_t& a, const uint64_t& b, const uint64_t& modulus) {
    uint64_t am = ( a < modulus ) ? a : a % modulus;
    if ( b == 0 ) {
    	return am;
    }
    uint64_t bm = ( b < modulus ) ? b : b % modulus;
    uint64_t b_from_m = modulus - bm;
    if ( am >= b_from_m ) {
    	return am - b_from_m;
    }
    return am + bm;
}

uint64_t multiply_modulus(const uint64_t& a, const uint64_t& b, const uint64_t& modulus) {
	uint64_t am = ( a < modulus ) ? a : a % modulus;
	uint64_t bm = ( b < modulus ) ? b : b % modulus;
    if ( bm > am ) {
    	std::swap(am, bm);
    }
    uint64_t result;
    while ( bm > 0 ) {
    	if ( ( bm & 1) == 1 ) {
    		result = add_modulus(result, am, modulus);
    	}
    	am = ( am << 1 ) - ( am >= ( modulus - am ) ? modulus : 0 );
		bm >>= 1;
    }
    return result;
}

uint64_t exponentiation_modulus(const uint64_t& base, const uint64_t& exponent, const uint64_t& modulus) {
	uint64_t b = base;
	uint64_t e = exponent;
	uint64_t result = 1;
	while ( e > 0 ) {
		if ( ( e & 1 ) == 1 ) {
			result = multiply_modulus(result, b, modulus);
		}
    	e >>= 1;
		b = multiply_modulus(b, b, modulus);
	}
	return result;
}

bool is_composite(const uint32_t& a, const uint64_t& d, const uint64_t& n, const uint32_t& s) {
    if ( exponentiation_modulus(a, d, n) == 1 ) {
        return false;
    }
    for ( uint64_t i = 0; i < s; ++i ) {
        if ( exponentiation_modulus(a, pow(2, i) * d, n) == n - 1 ) {
            return false;
        }
    }
    return true;
}

bool composite_test(const std::vector<uint32_t>& primes, const uint64_t& d, const uint64_t& n, const uint32_t& s) {
	for ( const uint32_t& prime : primes ) {
		if ( is_composite(prime, d, n, s) ) {
			return true;
		}
	}
	return false;
}

bool is_prime(const uint64_t& n) {
	if ( n == 0 || n == 1 ) {
		return false;
	}
    if ( std::find(small_primes.begin(), small_primes.end(), n) != small_primes.end() ) {
        return true;
    }
    if ( std::any_of(small_primes.begin(), small_primes.end(), [n](uint32_t p) { return n % p == 0; }) ) {
        return false;
    }

    uint64_t d = n - 1;
    uint32_t s = 0;
    while ( ! d % 2 ) {
        d >>= 1;
        s++;
    }

    if ( n < 1'373'653 ) {
    	return composite_test({ 2, 3 }, d, n, s);
    }
    if ( n < 25'326'001 ) {
        return composite_test({ 2, 3, 5 }, d, n, s);
    }
    if ( n < 118'670'087'467 ) {
        if ( n == 3'215'031'751 ) {
            return false;
        }
        return composite_test({ 2, 3, 5, 7 }, d, n, s);
    }
    if ( n < 2'152'302'898'747 ) {
        return composite_test({ 2, 3, 5, 7, 11 }, d, n, s);
    }
    if ( n < 3'474'749'660'383 ) {
        return composite_test({ 2, 3, 5, 7, 11, 13 }, d, n, s);
    }
    if ( n < 341'550'071'728'321 ) {
        return composite_test({ 2, 3, 5, 7, 11, 13, 17 }, d, n, s);
    }

    const std::vector<uint32_t> test_primes(small_primes.begin(), small_primes.begin() + 16);
    return composite_test(test_primes, d, n, s);
}

void create_small_primes() {
	for ( uint32_t i = 5; i < 1'000; i += 2 ) {
		if ( is_prime(i) ) {
			small_primes.emplace_back(i);
		}
	}
}

int main() {
	create_small_primes();

	for ( const uint64_t number : { 1'234'567'890'123'456'733, 1'234'567'890'123'456'737 } ) {
		std::cout << "is_prime(" << number << ") = " << std::boolalpha << is_prime(number) << std::endl;
	}
}
