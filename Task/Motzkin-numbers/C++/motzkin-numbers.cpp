#include <cstdint>
#include <iomanip>
#include <iostream>

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

class motzkin_generator {
public:
    uint64_t next();
private:
    uint64_t n = 0;
    uint64_t m0 = 1;
    uint64_t m1 = 1;
};

uint64_t motzkin_generator::next() {
    uint64_t m = n > 1 ? (m1 * (2 * n + 1) + m0 * (3 * n - 3)) / (n + 2) : 1;
    ++n;
    m0 = m1;
    m1 = m;
    return m;
}

int main() {
    std::cout.imbue(std::locale(""));
    std::cout << " n          M(n)             Prime?\n";
    std::cout << "-----------------------------------\n";
    std::cout << std::boolalpha;
    motzkin_generator mgen;
    for (int i = 0; i < 42; ++i) {
        uint64_t n = mgen.next();
        std::cout << std::setw(2) << i << std::setw(25) << n << "  "
                  << is_prime(n) << '\n';
    }
}
