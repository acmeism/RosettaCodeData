#include <cstdint>
#include <iostream>
#include <vector>

std::vector<bool> prime_sieve(uint64_t limit) {
    std::vector<bool> sieve(limit, true);
    if (limit > 0)
        sieve[0] = false;
    if (limit > 1)
        sieve[1] = false;
    for (uint64_t i = 4; i < limit; i += 2)
        sieve[i] = false;
    for (uint64_t p = 3; ; p += 2) {
        uint64_t q = p * p;
        if (q >= limit)
            break;
        if (sieve[p]) {
            uint64_t inc = 2 * p;
            for (; q < limit; q += inc)
                sieve[q] = false;
        }
    }
    return sieve;
}

uint64_t modpow(uint64_t base, uint64_t exp, uint64_t mod) {
    if (mod == 1)
        return 0;
    uint64_t result = 1;
    base %= mod;
    for (; exp > 0; exp >>= 1) {
        if ((exp & 1) == 1)
            result = (result * base) % mod;
        base = (base * base) % mod;
    }
    return result;
}

std::vector<uint64_t> wieferich_primes(uint64_t limit) {
    std::vector<uint64_t> result;
    std::vector<bool> sieve(prime_sieve(limit));
    for (uint64_t p = 2; p < limit; ++p)
        if (sieve[p] && modpow(2, p - 1, p * p) == 1)
            result.push_back(p);
    return result;
}

int main() {
    const uint64_t limit = 5000;
    std::cout << "Wieferich primes less than " << limit << ":\n";
    for (uint64_t p : wieferich_primes(limit))
        std::cout << p << '\n';
}
