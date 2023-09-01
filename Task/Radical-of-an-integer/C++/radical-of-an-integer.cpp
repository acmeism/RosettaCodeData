#include <iomanip>
#include <iostream>
#include <map>
#include <vector>

int radical(int n, int& count) {
    if (n == 1) {
        count = 1;
        return 1;
    }
    int product = 1;
    count = 0;
    if ((n & 1) == 0) {
        product *= 2;
        ++count;
        while ((n & 1) == 0)
            n >>= 1;
    }
    for (int p = 3, sq = 9; sq <= n; p += 2) {
        if (n % p == 0) {
            product *= p;
            ++count;
            while (n % p == 0)
                n /= p;
        }
        sq += (p + 1) << 2;
    }
    if (n > 1) {
        product *= n;
        ++count;
    }
    return product;
}

std::vector<bool> prime_sieve(int limit) {
    std::vector<bool> sieve(limit, true);
    if (limit > 0)
        sieve[0] = false;
    if (limit > 1)
        sieve[1] = false;
    for (int i = 4; i < limit; i += 2)
        sieve[i] = false;
    for (int p = 3, sq = 9; sq < limit; p += 2) {
        if (sieve[p]) {
            for (int q = sq; q < limit; q += p << 1)
                sieve[q] = false;
        }
        sq += (p + 1) << 2;
    }
    return sieve;
}

int main() {
    std::cout.imbue(std::locale(""));
    std::cout << "Radicals of the first 50 positive integers:\n";
    int count = 0;
    for (int i = 1; i <= 50; ++i) {
        std::cout << std::setw(2) << radical(i, count)
                  << (i % 10 == 0 ? '\n' : ' ');
    }
    std::cout << '\n';
    for (int i : {99999, 499999, 999999}) {
        std::cout << "Radical of " << std::setw(7) << i << " is "
                  << std::setw(7) << radical(i, count) << ".\n";
    }
    std::map<int, int> prime_factors;
    const int limit = 1000000;
    for (int i = 1; i <= limit; ++i) {
        radical(i, count);
        ++prime_factors[count];
    }
    std::cout << "\nRadical factor count breakdown up to " << limit << ":\n";
    for (const auto& [count, total] : prime_factors) {
        std::cout << count << ": " << std::setw(7) << total << '\n';
    }
    auto sieve = prime_sieve(limit + 1);
    int primes = 0, prime_powers = 0;
    for (int i = 1; i <= limit; ++i) {
        if (sieve[i]) {
            ++primes;
            int n = limit;
            while (i <= n / i) {
                ++prime_powers;
                n /= i;
            }
        }
    }
    std::cout << "\nUp to " << limit << ":\n";
    std::cout << "Primes: " << std::setw(6) << primes
              << "\nPowers: " << std::setw(6) << prime_powers
              << "\nPlus 1: " << std::setw(6) << 1
              << "\nTotal:  " << std::setw(6) << primes + prime_powers + 1
              << '\n';
}
