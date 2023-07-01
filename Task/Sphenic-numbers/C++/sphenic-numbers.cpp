#include <algorithm>
#include <cassert>
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

std::vector<int> prime_factors(int n) {
    std::vector<int> factors;
    if (n > 1 && (n & 1) == 0) {
        factors.push_back(2);
        while ((n & 1) == 0)
            n >>= 1;
    }
    for (int p = 3; p * p <= n; p += 2) {
        if (n % p == 0) {
            factors.push_back(p);
            while (n % p == 0)
                n /= p;
        }
    }
    if (n > 1)
        factors.push_back(n);
    return factors;
}

int main() {
    const int limit = 1000000;
    const int imax = limit / 6;
    std::vector<bool> sieve = prime_sieve(imax + 1);
    std::vector<bool> sphenic(limit + 1, false);
    for (int i = 0; i <= imax; ++i) {
        if (!sieve[i])
            continue;
        int jmax = std::min(imax, limit / (i * i));
        if (jmax <= i)
            break;
        for (int j = i + 1; j <= jmax; ++j) {
            if (!sieve[j])
                continue;
            int p = i * j;
            int kmax = std::min(imax, limit / p);
            if (kmax <= j)
                break;
            for (int k = j + 1; k <= kmax; ++k) {
                if (!sieve[k])
                    continue;
                assert(p * k <= limit);
                sphenic[p * k] = true;
            }
        }
    }

    std::cout << "Sphenic numbers < 1000:\n";
    for (int i = 0, n = 0; i < 1000; ++i) {
        if (!sphenic[i])
            continue;
        ++n;
        std::cout << std::setw(3) << i << (n % 15 == 0 ? '\n' : ' ');
    }

    std::cout << "\nSphenic triplets < 10,000:\n";
    for (int i = 0, n = 0; i < 10000; ++i) {
        if (i > 1 && sphenic[i] && sphenic[i - 1] && sphenic[i - 2]) {
            ++n;
            std::cout << "(" << i - 2 << ", " << i - 1 << ", " << i << ")"
                      << (n % 3 == 0 ? '\n' : ' ');
        }
    }

    int count = 0, triplets = 0, s200000 = 0, t5000 = 0;
    for (int i = 0; i < limit; ++i) {
        if (!sphenic[i])
            continue;
        ++count;
        if (count == 200000)
            s200000 = i;
        if (i > 1 && sphenic[i - 1] && sphenic[i - 2]) {
            ++triplets;
            if (triplets == 5000)
                t5000 = i;
        }
    }

    std::cout << "\nNumber of sphenic numbers < 1,000,000: " << count << '\n';
    std::cout << "Number of sphenic triplets < 1,000,000: " << triplets << '\n';

    auto factors = prime_factors(s200000);
    assert(factors.size() == 3);
    std::cout << "The 200,000th sphenic number: " << s200000 << " = "
              << factors[0] << " * " << factors[1] << " * " << factors[2]
              << '\n';

    std::cout << "The 5,000th sphenic triplet: (" << t5000 - 2 << ", "
              << t5000 - 1 << ", " << t5000 << ")\n";
}
