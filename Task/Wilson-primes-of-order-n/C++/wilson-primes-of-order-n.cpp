#include <iomanip>
#include <iostream>
#include <vector>
#include <gmpxx.h>

std::vector<int> generate_primes(int limit) {
    std::vector<bool> sieve(limit >> 1, true);
    for (int p = 3, s = 9; s < limit; p += 2) {
        if (sieve[p >> 1]) {
            for (int q = s; q < limit; q += p << 1)
                sieve[q >> 1] = false;
        }
        s += (p + 1) << 2;
    }
    std::vector<int> primes;
    if (limit > 2)
        primes.push_back(2);
    for (int i = 1; i < sieve.size(); ++i) {
        if (sieve[i])
            primes.push_back((i << 1) + 1);
    }
    return primes;
}

int main() {
    using big_int = mpz_class;
    const int limit = 11000;
    std::vector<big_int> f{1};
    f.reserve(limit);
    big_int factorial = 1;
    for (int i = 1; i < limit; ++i) {
        factorial *= i;
        f.push_back(factorial);
    }
    std::vector<int> primes = generate_primes(limit);
    std::cout << " n | Wilson primes\n--------------------\n";
    for (int n = 1, s = -1; n <= 11; ++n, s = -s) {
        std::cout << std::setw(2) << n << " |";
        for (int p : primes) {
            if (p >= n && (f[n - 1] * f[p - n] - s) % (p * p) == 0)
                std::cout << ' ' << p;
        }
        std::cout << '\n';
    }
}
