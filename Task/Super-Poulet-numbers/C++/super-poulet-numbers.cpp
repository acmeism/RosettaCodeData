#include <algorithm>
#include <iostream>
#include <vector>

std::vector<unsigned int> divisors(unsigned int n) {
    std::vector<unsigned int> result{1};
    unsigned int power = 2;
    for (; (n & 1) == 0; power <<= 1, n >>= 1)
        result.push_back(power);
    for (unsigned int p = 3; p * p <= n; p += 2) {
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
    return result;
}

unsigned long long modpow(unsigned long long base, unsigned int exp,
                          unsigned int mod) {
    if (mod == 1)
        return 0;
    unsigned long long result = 1;
    base %= mod;
    for (; exp != 0; exp >>= 1) {
        if ((exp & 1) == 1)
            result = (result * base) % mod;
        base = (base * base) % mod;
    }
    return result;
}

bool is_prime(unsigned int n) {
    if (n < 2)
        return false;
    if (n % 2 == 0)
        return n == 2;
    if (n % 3 == 0)
        return n == 3;
    if (n % 5 == 0)
        return n == 5;
    static constexpr unsigned int wheel[] = {4, 2, 4, 2, 4, 6, 2, 6};
    for (unsigned int p = 7;;) {
        for (unsigned int w : wheel) {
            if (p * p > n)
                return true;
            if (n % p == 0)
                return false;
            p += w;
        }
    }
}

bool is_poulet_number(unsigned int n) {
    return modpow(2, n - 1, n) == 1 && !is_prime(n);
}

bool is_sp_num(unsigned int n) {
    if (!is_poulet_number(n))
        return false;
    auto div = divisors(n);
    return all_of(div.begin() + 1, div.end(),
                  [](unsigned int d) { return modpow(2, d, d) == 2; });
}

int main() {
    std::cout.imbue(std::locale(""));
    unsigned int n = 1, count = 0;
    std::cout << "First 20 super-Poulet numbers:\n";
    for (; count < 20; n += 2) {
        if (is_sp_num(n)) {
            ++count;
            std::cout << n << ' ';
        }
    }
    std::cout << '\n';
    for (unsigned int limit = 1000000; limit <= 10000000; limit *= 10) {
        for (;;) {
            n += 2;
            if (is_sp_num(n)) {
                ++count;
                if (n > limit)
                    break;
            }
        }
        std::cout << "\nIndex and value of first super-Poulet greater than "
                  << limit << ":\n#" << count << " is " << n << '\n';
    }
}
