#include <cstdint>
#include <iomanip>
#include <iostream>

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

bool is_fermat_pseudoprime(uint64_t a, uint64_t x) {
    return !is_prime(x) && modpow(a, x - 1, x) == 1;
}

int main() {
    std::cout << "First 20 Fermat pseudoprimes:\n";
    for (uint64_t a = 1; a <= 20; ++a) {
        std::cout << "Base " << std::setw(2) << a << ": ";
        int count = 0;
        for (uint64_t x = 4; count < 20; ++x) {
            if (is_fermat_pseudoprime(a, x)) {
                ++count;
                std::cout << std::setw(5) << x << ' ';
            }
        }
        std::cout << '\n';
    }

    const uint64_t limits[] = {12000, 25000, 50000, 100000};
    std::cout << "\nCount <= ";
    for (uint64_t limit : limits) {
        std::cout << std::setw(6) << limit << ' ';
    }
    std::cout << "\n------------------------------------\n";
    for (uint64_t a = 1; a <= 20; ++a) {
        std::cout << "Base " << std::setw(2) << a << ": ";
        int count = 0;
        uint64_t x = 4;
        for (uint64_t limit : limits) {
            for (; x <= limit; ++x) {
                if (is_fermat_pseudoprime(a, x))
                    ++count;
            }
            std::cout << std::setw(6) << count << ' ';
        }
        std::cout << '\n';
    }
}
