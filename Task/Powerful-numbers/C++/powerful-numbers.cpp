#include <algorithm>
#include <cmath>
#include <cstdint>
#include <iostream>
#include <numeric>
#include <vector>

bool is_square_free(uint64_t n) {
    if (n % 4 == 0)
        return false;
    for (uint64_t p = 3; p * p <= n; p += 2) {
        uint64_t count = 0;
        for (; n % p == 0; n /= p) {
            if (++count > 1)
                return false;
        }
    }
    return true;
}

uint64_t iroot(uint64_t n, uint64_t r) {
    // adjustment to ensure f/p square root exact for perfect integer squares
    static constexpr double adj = 1e-6;
    return static_cast<uint64_t>(std::pow(n, 1.0/r) + adj);
}

uint64_t ipow(uint64_t n, uint64_t p) {
    uint64_t prod = 1;
    for (; p > 0; p >>= 1) {
        if (p & 1)
            prod *= n;
        n *= n;
    }
    return prod;
}

std::vector<uint64_t> powerful(uint64_t n, uint64_t k) {
    std::vector<uint64_t> result;
    std::function<void(uint64_t, uint64_t)> f = [&](uint64_t m, uint64_t r) {
        if (r < k) {
            result.push_back(m);
            return;
        }
        uint64_t root = iroot(n/m, r);
        for (uint64_t v = 1; v <= root; ++v) {
            if (r > k && (!is_square_free(v) || std::gcd(m, v) != 1))
                continue;
            f(m * ipow(v, r), r - 1);
        }
    };
    f(1, 2*k - 1);
    std::sort(result.begin(), result.end());
    return result;
}

uint64_t powerful_count(uint64_t n, uint64_t k) {
    uint64_t count = 0;
    std::function<void(uint64_t, uint64_t)> f = [&](uint64_t m, uint64_t r) {
        if (r <= k) {
            count += iroot(n/m, r);
            return;
        }
        uint64_t root = iroot(n/m, r);
        for (uint64_t v = 1; v <= root; ++v) {
            if (is_square_free(v) && std::gcd(m, v) == 1)
                f(m * ipow(v, r), r - 1);
        }
    };
    f(1, 2*k - 1);
    return count;
}

int main() {
    const size_t max = 5;
    for (uint64_t k = 2, p = 100; k <= 10; ++k, p *= 10) {
        auto result = powerful(p, k);
        std::cout << result.size() << " " << k
            << "-powerful numbers <= 10^" << k << ":";
        for (size_t i = 0; i < result.size(); ++i) {
            if (i == max)
                std::cout << " ...";
            else if (i < max || i + max >= result.size())
                std::cout << ' ' << result[i];
        }
        std::cout << '\n';
    }
    std::cout << '\n';
    for (uint64_t k = 2; k <= 10; ++k) {
        std::cout << "Count of " << k << "-powerful numbers <= 10^j for 0 <= j < "
            << k + 10 << ":";
        for (uint64_t j = 0, p = 1; j < k + 10; ++j, p *= 10)
            std::cout << ' ' << powerful_count(p, k);
        std::cout << '\n';
    }
}
