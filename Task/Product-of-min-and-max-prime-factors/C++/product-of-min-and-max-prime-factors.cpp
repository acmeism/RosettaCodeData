#include <iomanip>
#include <iostream>
#include <utility>

auto min_max_prime_factors(unsigned int n) {
    unsigned int min_factor = 1;
    unsigned int max_factor = 1;
    if ((n & 1) == 0) {
        while ((n & 1) == 0)
            n >>= 1;
        min_factor = 2;
        max_factor = 2;
    }
    for (unsigned int p = 3; p * p <= n; p += 2) {
        if (n % p == 0) {
            while (n % p == 0)
                n /= p;
            if (min_factor == 1)
                min_factor = p;
            max_factor = p;
        }
    }
    if (n > 1) {
        if (min_factor == 1)
            min_factor = n;
        max_factor = n;
    }
    return std::make_pair(min_factor, max_factor);
}

int main() {
    std::cout << "Product of smallest and greatest prime factors of n for 1 to "
                 "100:\n";
    for (unsigned int n = 1; n <= 100; ++n) {
        auto p = min_max_prime_factors(n);
        std::cout << std::setw(4) << p.first * p.second
                  << (n % 10 == 0 ? '\n' : ' ');
    }
}
