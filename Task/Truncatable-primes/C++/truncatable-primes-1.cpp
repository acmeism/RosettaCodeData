#include <iostream>
#include "prime_sieve.hpp"

bool is_left_truncatable(const prime_sieve& sieve, int p) {
    for (int n = 10, q = p; p > n; n *= 10) {
        if (!sieve.is_prime(p % n) || q == p % n)
            return false;
        q = p % n;
    }
    return true;
}

bool is_right_truncatable(const prime_sieve& sieve, int p) {
    for (int q = p/10; q > 0; q /= 10) {
        if (!sieve.is_prime(q))
            return false;
    }
    return true;
}

int main() {
    const int limit = 1000000;

    // find the prime numbers up to the limit
    prime_sieve sieve(limit + 1);

    int largest_left = 0;
    int largest_right = 0;
    // find largest left truncatable prime
    for (int p = limit; p >= 2; --p) {
        if (sieve.is_prime(p) && is_left_truncatable(sieve, p)) {
            largest_left = p;
            break;
        }
    }
    // find largest right truncatable prime
    for (int p = limit; p >= 2; --p) {
        if (sieve.is_prime(p) && is_right_truncatable(sieve, p)) {
            largest_right = p;
            break;
        }
    }
    // write results to standard output
    std::cout << "Largest left truncatable prime is " << largest_left << '\n';
    std::cout << "Largest right truncatable prime is " << largest_right << '\n';
    return 0;
}
