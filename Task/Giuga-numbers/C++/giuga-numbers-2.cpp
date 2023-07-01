#include <boost/rational.hpp>

#include <algorithm>
#include <cstdint>
#include <iostream>
#include <vector>

using rational = boost::rational<uint64_t>;

bool is_prime(uint64_t n) {
    if (n < 2)
        return false;
    if (n % 2 == 0)
        return n == 2;
    if (n % 3 == 0)
        return n == 3;
    for (uint64_t p = 5; p * p <= n; p += 4) {
        if (n % p == 0)
            return false;
        p += 2;
        if (n % p == 0)
            return false;
    }
    return true;
}

uint64_t next_prime(uint64_t n) {
    while (!is_prime(n))
        ++n;
    return n;
}

std::vector<uint64_t> divisors(uint64_t n) {
    std::vector<uint64_t> div{1};
    for (uint64_t i = 2; i * i <= n; ++i) {
        if (n % i == 0) {
            div.push_back(i);
            if (i * i != n)
                div.push_back(n / i);
        }
    }
    div.push_back(n);
    sort(div.begin(), div.end());
    return div;
}

void giuga_numbers(uint64_t n) {
    std::cout << "n = " << n << ":";
    std::vector<uint64_t> p(n, 0);
    std::vector<rational> s(n, 0);
    p[2] = 2;
    p[1] = 2;
    s[1] = rational(1, 2);
    for (uint64_t t = 2; t > 1;) {
        p[t] = next_prime(p[t] + 1);
        s[t] = s[t - 1] + rational(1, p[t]);
        if (s[t] == 1 || s[t] + rational(n - t, p[t]) <= rational(1)) {
            --t;
        } else if (t < n - 2) {
            ++t;
            uint64_t c = s[t - 1].numerator();
            uint64_t d = s[t - 1].denominator();
            p[t] = std::max(p[t - 1], c / (d - c));
        } else {
            uint64_t c = s[n - 2].numerator();
            uint64_t d = s[n - 2].denominator();
            uint64_t k = d * d + c - d;
            auto div = divisors(k);
            uint64_t count = (div.size() + 1) / 2;
            for (uint64_t i = 0; i < count; ++i) {
                uint64_t h = div[i];
                if ((h + d) % (d - c) == 0 && (k / h + d) % (d - c) == 0) {
                    uint64_t r1 = (h + d) / (d - c);
                    uint64_t r2 = (k / h + d) / (d - c);
                    if (r1 > p[n - 2] && r2 > p[n - 2] && r1 != r2 &&
                        is_prime(r1) && is_prime(r2)) {
                        std::cout << ' ' << d * r1 * r2;
                    }
                }
            }
        }
    }
    std::cout << '\n';
}

int main() {
    for (uint64_t n = 3; n < 7; ++n)
        giuga_numbers(n);
}
