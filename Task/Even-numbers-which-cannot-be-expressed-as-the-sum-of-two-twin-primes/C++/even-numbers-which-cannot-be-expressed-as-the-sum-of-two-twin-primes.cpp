#include <iomanip>
#include <iostream>
#include <vector>

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

void print_non_twin_prime_sums(const std::vector<bool>& sums) {
    int count = 0;
    for (size_t i = 2; i < sums.size(); i += 2) {
        if (!sums[i]) {
            ++count;
            std::cout << std::setw(4) << i << (count % 10 == 0 ? '\n' : ' ');
        }
    }
    std::cout << "\nFound " << count << '\n';
}

int main() {
    const int limit = 100001;

    std::vector<bool> sieve = prime_sieve(limit + 2);
    // remove non-twin primes from the sieve
    for (size_t i = 0; i < limit; ++i) {
        if (sieve[i] && !((i > 1 && sieve[i - 2]) || sieve[i + 2]))
            sieve[i] = false;
    }

    std::vector<bool> twin_prime_sums(limit, false);
    for (size_t i = 0; i < limit; ++i) {
        if (sieve[i]) {
            for (size_t j = i; i + j < limit; ++j) {
                if (sieve[j])
                    twin_prime_sums[i + j] = true;
            }
        }
    }

    std::cout << "Non twin prime sums:\n";
    print_non_twin_prime_sums(twin_prime_sums);

    sieve[1] = true;
    for (size_t i = 1; i + 1 < limit; ++i) {
        if (sieve[i])
            twin_prime_sums[i + 1] = true;
    }

    std::cout << "\nNon twin prime sums (including 1):\n";
    print_non_twin_prime_sums(twin_prime_sums);
}
