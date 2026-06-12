#include <algorithm>
#include <cassert>
#include <cstdint>
#include <iomanip>
#include <iostream>
#include <vector>

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

class undulating_number_generator {
public:
    explicit undulating_number_generator(int base) : base_(base) {}

    uint64_t next() {
        uint64_t n = 0;
        for (int d = 0; d < digits_; ++d)
            n = n * base_ + (d % 2 == 0 ? a_ : b_);
        ++b_;
        if (a_ == b_)
            ++b_;
        if (b_ == base_) {
            ++a_;
            b_ = 0;
            if (a_ == base_) {
                a_ = 1;
                ++digits_;
            }
        }
        return n;
    }

private:
    int base_;
    int a_ = 1;
    int b_ = 0;
    int digits_ = 3;
};

std::string to_string(uint64_t n, int base) {
    assert(base > 1 && base <= 16);
    const char digits[] = "0123456789ABCDEF";
    std::string str;
    for (; n > 0; n /= base)
        str += digits[n % base];
    reverse(str.begin(), str.end());
    return str;
}

void undulating(int base) {
    undulating_number_generator gen(base);
    uint64_t n = gen.next();
    int i = 1;
    uint64_t limit = base * base * base;
    std::vector<uint64_t> primes;
    std::cout << "3-digit undulating numbers in base " << base << ":\n";
    for (; n < limit; ++i) {
        std::cout << std::setw(3) << n << (i % 9 == 0 ? '\n' : ' ');
        if (is_prime(n))
            primes.push_back(n);
        n = gen.next();
    }
    limit *= base;
    std::cout << "\n4-digit undulating numbers in base " << base << ":\n";
    for (; n < limit; ++i) {
        std::cout << std::setw(4) << n << (i % 9 == 0 ? '\n' : ' ');
        n = gen.next();
    }
    std::cout << "\n3-digit undulating numbers in base " << base
              << " which are prime:\n";
    for (auto prime : primes)
        std::cout << prime << ' ';
    std::cout << '\n';
    for (; i != 600; ++i)
        n = gen.next();
    std::cout << "\nThe 600th undulating number in base " << base << " is "
              << n;
    if (base != 10) {
        std::cout << "\nor expressed in base " << base << ": "
                  << to_string(n, base);
    }
    std::cout << ".\n";
    for (;; ++i) {
        uint64_t next = gen.next();
        if (next >= (1ULL << 53))
            break;
        n = next;
    }
    std::cout << "\nTotal number of undulating numbers < 2^53 in base " << base
              << ": " << i << "\nof which the largest is " << n;
    if (base != 10) {
        std::cout << "\nor expressed in base " << base << ": "
                  << to_string(n, base);
    }
    std::cout << ".\n";
}

int main() {
    undulating(10);
    std::cout << '\n';
    undulating(7);
}
