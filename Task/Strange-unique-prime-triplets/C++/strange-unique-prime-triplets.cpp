#include <iomanip>
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

void strange_unique_prime_triplets(int limit, bool verbose) {
    std::vector<bool> sieve = prime_sieve(limit * 3);
    std::vector<int> primes;
    for (int p = 3; p < limit; p += 2) {
        if (sieve[p])
            primes.push_back(p);
    }
    size_t n = primes.size();
    size_t count = 0;
    if (verbose)
        std::cout << "Strange unique prime triplets < " << limit << ":\n";
    for (size_t i = 0; i + 2 < n; ++i) {
        for (size_t j = i + 1; j + 1 < n; ++j) {
            for (size_t k = j + 1; k < n; ++k) {
                int sum = primes[i] + primes[j] + primes[k];
                if (sieve[sum]) {
                    ++count;
                    if (verbose) {
                        std::cout << std::setw(2) << primes[i] << " + "
                                  << std::setw(2) << primes[j] << " + "
                                  << std::setw(2) << primes[k] << " = " << sum
                                  << '\n';
                    }
                }
            }
        }
    }
    std::cout << "\nCount of strange unique prime triplets < " << limit
              << " is " << count << ".\n";
}

int main() {
    strange_unique_prime_triplets(30, true);
    strange_unique_prime_triplets(1000, false);
    return 0;
}
