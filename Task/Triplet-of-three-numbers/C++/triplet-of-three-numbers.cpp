#include <iostream>
#include <vector>
#include <cmath>

constexpr unsigned int LIMIT = 6000;

std::vector<bool> primes(unsigned int limit) {
    std::vector<bool> p(limit + 1, true);
    unsigned int root = std::sqrt(limit);

    p[0] = false;
    p[1] = false;

    for (size_t i = 2; i <= root; i++) {
        if (p[i]) {
            for (size_t j = 2 * i; j <= limit; j += i) {
                p[j] = false;
            }
        }
    }

    return p;
}

bool triplet(const std::vector<bool> &p, unsigned int n) {
    return n >= 2 && p[n - 1] && p[n + 3] && p[n + 5];
}

int main() {
    std::vector<bool> p = primes(LIMIT);

    for (size_t i = 2; i < LIMIT; i++) {
        if (triplet(p, i)) {
            printf("%4d: %4d, %4d, %4d\n", i, i - 1, i + 3, i + 5);
        }
    }

    return 0;
}
