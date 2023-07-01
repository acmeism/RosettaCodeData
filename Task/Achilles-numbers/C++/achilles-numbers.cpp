#include <algorithm>
#include <chrono>
#include <cmath>
#include <cstdint>
#include <iomanip>
#include <iostream>
#include <vector>

#include <boost/multiprecision/cpp_int.hpp>

using boost::multiprecision::uint128_t;

template <typename T> void unique_sort(std::vector<T>& vector) {
    std::sort(vector.begin(), vector.end());
    vector.erase(std::unique(vector.begin(), vector.end()), vector.end());
}

auto perfect_powers(uint128_t n) {
    std::vector<uint128_t> result;
    for (uint128_t i = 2, s = sqrt(n); i <= s; ++i)
        for (uint128_t p = i * i; p < n; p *= i)
            result.push_back(p);
    unique_sort(result);
    return result;
}

auto achilles(uint128_t from, uint128_t to, const std::vector<uint128_t>& pps) {
    std::vector<uint128_t> result;
    auto c = static_cast<uint128_t>(std::cbrt(static_cast<double>(to / 4)));
    auto s = sqrt(to / 8);
    for (uint128_t b = 2; b <= c; ++b) {
        uint128_t b3 = b * b * b;
        for (uint128_t a = 2; a <= s; ++a) {
            uint128_t p = b3 * a * a;
            if (p >= to)
                break;
            if (p >= from && !binary_search(pps.begin(), pps.end(), p))
                result.push_back(p);
        }
    }
    unique_sort(result);
    return result;
}

uint128_t totient(uint128_t n) {
    uint128_t tot = n;
    if ((n & 1) == 0) {
        while ((n & 1) == 0)
            n >>= 1;
        tot -= tot >> 1;
    }
    for (uint128_t p = 3; p * p <= n; p += 2) {
        if (n % p == 0) {
            while (n % p == 0)
                n /= p;
            tot -= tot / p;
        }
    }
    if (n > 1)
        tot -= tot / n;
    return tot;
}

int main() {
    auto start = std::chrono::high_resolution_clock::now();

    const uint128_t limit = 1000000000000000;

    auto pps = perfect_powers(limit);
    auto ach = achilles(1, 1000000, pps);

    std::cout << "First 50 Achilles numbers:\n";
    for (size_t i = 0; i < 50 && i < ach.size(); ++i)
        std::cout << std::setw(4) << ach[i] << ((i + 1) % 10 == 0 ? '\n' : ' ');

    std::cout << "\nFirst 50 strong Achilles numbers:\n";
    for (size_t i = 0, count = 0; count < 50 && i < ach.size(); ++i)
        if (binary_search(ach.begin(), ach.end(), totient(ach[i])))
            std::cout << std::setw(6) << ach[i]
                      << (++count % 10 == 0 ? '\n' : ' ');

    int digits = 2;
    std::cout << "\nNumber of Achilles numbers with:\n";
    for (uint128_t from = 1, to = 100; to <= limit; to *= 10, ++digits) {
        size_t count = achilles(from, to, pps).size();
        std::cout << std::setw(2) << digits << " digits: " << count << '\n';
        from = to;
    }

    auto end = std::chrono::high_resolution_clock::now();
    std::chrono::duration<double> duration(end - start);
    std::cout << "\nElapsed time: " << duration.count() << " seconds\n";
}
