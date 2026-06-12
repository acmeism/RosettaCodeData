#include <cstdint>
#include <iomanip>
#include <iostream>
#include <primesieve.hpp>

bool is_prime(uint64_t n) {
    if (n < 2)
        return false;
    if (n % 2 == 0)
        return n == 2;
    if (n % 3 == 0)
        return n == 3;
    for (uint64_t p = 5; p * p <= n; p += 4) {
        if (n % p == 0)
            return false;
        p += 2;
        if (n % p == 0)
            return false;
    }
    return true;
}

int main() {
    const uint64_t limit = 1000000;
    std::cout << "Frobenius numbers less than " << limit
              << " (asterisk marks primes):\n";
    primesieve::iterator it;
    uint64_t prime1 = it.next_prime();
    for (int count = 1;; ++count) {
        uint64_t prime2 = it.next_prime();
        uint64_t frobenius = prime1 * prime2 - prime1 - prime2;
        if (frobenius >= limit)
            break;
        std::cout << std::setw(6) << frobenius
                  << (is_prime(frobenius) ? '*' : ' ')
                  << (count % 10 == 0 ? '\n' : ' ');
        prime1 = prime2;
    }
    std::cout << '\n';
}
