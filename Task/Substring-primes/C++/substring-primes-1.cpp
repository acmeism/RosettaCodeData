#include <iostream>
#include <vector>

std::vector<bool> prime_sieve(size_t limit) {
    std::vector<bool> sieve(limit, true);
    if (limit > 0)
        sieve[0] = false;
    if (limit > 1)
        sieve[1] = false;
    for (size_t i = 4; i < limit; i += 2)
        sieve[i] = false;
    for (size_t p = 3; ; p += 2) {
        size_t q = p * p;
        if (q >= limit)
            break;
        if (sieve[p]) {
            size_t inc = 2 * p;
            for (; q < limit; q += inc)
                sieve[q] = false;
        }
    }
    return sieve;
}

bool substring_prime(const std::vector<bool>& sieve, unsigned int n) {
    for (; n != 0; n /= 10) {
        if (!sieve[n])
            return false;
        for (unsigned int p = 10; p < n; p *= 10) {
            if (!sieve[n % p])
                return false;
        }
    }
    return true;
}

int main() {
    const unsigned int limit = 500;
    std::vector<bool> sieve = prime_sieve(limit);
    for (unsigned int i = 2; i < limit; ++i) {
        if (substring_prime(sieve, i))
            std::cout << i << '\n';
    }
    return 0;
}
