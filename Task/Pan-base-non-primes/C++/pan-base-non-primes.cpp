#include <algorithm>
#include <cassert>
#include <cstdint>
#include <iomanip>
#include <iostream>
#include <numeric>
#include <vector>

bool is_prime(uint64_t n) {
    if (n < 2)
        return false;
    if (n % 2 == 0)
        return n == 2;
    if (n % 3 == 0)
        return n == 3;
    if (n % 5 == 0)
        return n == 5;
    static constexpr uint64_t wheel[] = {4, 2, 4, 2, 4, 6, 2, 6};
    for (uint64_t p = 7;;) {
        for (uint64_t w : wheel) {
            if (p * p > n)
                return true;
            if (n % p == 0)
                return false;
            p += w;
        }
    }
}

std::vector<uint64_t> digits(uint64_t n) {
    std::vector<uint64_t> d;
    for (uint64_t m = n; m > 0; m /= 10)
        d.push_back(m % 10);
    reverse(d.begin(), d.end());
    return d;
}

template <typename iterator> auto gcd(iterator begin, iterator end) {
    assert(begin != end);
    auto result = *begin++;
    for (; begin != end; ++begin)
        result = std::gcd(result, *begin);
    return result;
}

template <typename number, typename iterator>
number polyval(iterator begin, iterator end, number value) {
    number n = 0;
    for (auto i = begin; i != end; ++i)
        n = n * value + *i;
    return n;
}

bool is_pan_base_non_prime(uint64_t n) {
    if (n < 10)
        return !is_prime(n);
    if (n > 10 && n % 10 == 0)
        return true;
    auto d = digits(n);
    if (gcd(d.begin(), d.end()) > 1)
        return true;
    auto max_digit = *std::max_element(d.begin(), d.end());
    for (uint64_t base = max_digit + 1; base <= n; ++base) {
        if (is_prime(polyval(d.begin(), d.end(), base)))
            return false;
    }
    return true;
}

int main() {
    std::vector<uint64_t> pbnp;
    const uint64_t limit = 10000;
    for (uint64_t n = 2; n <= limit; ++n) {
        if (is_pan_base_non_prime(n))
            pbnp.push_back(n);
    }

    std::cout << "First 50 pan-base composites:\n";
    for (size_t i = 0; i < 50; ++i) {
        std::cout << std::setw(3) << pbnp[i]
                  << ((i + 1) % 10 == 0 ? '\n' : ' ');
    }

    std::cout << "\nFirst 20 odd pan-base composites:\n";
    for (size_t i = 0, count = 0; count < 20; ++i) {
        if (pbnp[i] % 2 == 1) {
            ++count;
            std::cout << std::setw(3) << pbnp[i]
                      << (count % 10 == 0 ? '\n' : ' ');
        }
    }

    size_t total = pbnp.size();
    size_t odd = std::count_if(pbnp.begin(), pbnp.end(),
                               [](uint64_t n) { return n % 2 == 1; });
    std::cout << "\nCount of pan-base composites up to and including " << limit
              << ": " << total << '\n';
    auto percent = (100.0 * odd) / total;
    std::cout << std::fixed;
    std::cout << "Percent odd  up to and including " << limit << ": " << percent
              << '\n';
    std::cout << "Percent even up to and including " << limit << ": "
              << 100.0 - percent << '\n';
}
