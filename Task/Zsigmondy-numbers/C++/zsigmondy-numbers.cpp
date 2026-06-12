#include <algorithm>
#include <cstdint>
#include <iostream>
#include <numeric>
#include <vector>

std::vector<uint64_t> divisors(uint64_t n) {
    std::vector<uint64_t> result{1};
    uint64_t power = 2;
    for (; (n & 1) == 0; power <<= 1, n >>= 1)
        result.push_back(power);
    for (uint64_t p = 3; p * p <= n; p += 2) {
        size_t size = result.size();
        for (power = p; n % p == 0; power *= p, n /= p)
            for (size_t i = 0; i != size; ++i)
                result.push_back(power * result[i]);
    }
    if (n > 1) {
        size_t size = result.size();
        for (size_t i = 0; i != size; ++i)
            result.push_back(n * result[i]);
    }
    sort(result.begin(), result.end());
    return result;
}

uint64_t ipow(uint64_t base, uint64_t exp) {
    if (exp == 0)
        return 1;
    if ((exp & 1) == 0)
        return ipow(base * base, exp >> 1);
    return base * ipow(base * base, (exp - 1) >> 1);
}

uint64_t zsigmondy(uint64_t n, uint64_t a, uint64_t b) {
    auto p = ipow(a, n) - ipow(b, n);
    auto d = divisors(p);
    if (d.size() == 2)
        return p;
    std::vector<uint64_t> dms(n - 1);
    for (uint64_t m = 1; m < n; ++m)
        dms[m - 1] = ipow(a, m) - ipow(b, m);
    for (auto i = d.rbegin(); i != d.rend(); ++i) {
        uint64_t z = *i;
        if (all_of(dms.begin(), dms.end(),
                   [z](uint64_t x) { return std::gcd(x, z) == 1; }))
            return z;
    }
    return 1;
}

void test(uint64_t a, uint64_t b) {
    std::cout << "Zsigmondy(n, " << a << ", " << b << "):\n";
    for (uint64_t n = 1; n <= 20; ++n) {
        std::cout << zsigmondy(n, a, b) << ' ';
    }
    std::cout << "\n\n";
}

int main() {
    test(2, 1);
    test(3, 1);
    test(4, 1);
    test(5, 1);
    test(6, 1);
    test(7, 1);
    test(3, 2);
    test(5, 3);
    test(7, 3);
    test(7, 5);
}
