#include <cstdint>
#include <iomanip>
#include <iostream>
#include <vector>

uint64_t modpow(uint64_t base, uint64_t exp, uint64_t mod) {
    if (mod == 1)
        return 0;
    uint64_t result = 1;
    base %= mod;
    for (; exp > 0; exp >>= 1) {
        if ((exp & 1) == 1)
            result = (result * base) % mod;
        base = (base * base) % mod;
    }
    return result;
}

bool is_curzon(uint64_t n, uint64_t k) {
    const uint64_t r = k * n;
    return modpow(k, n, r + 1) == r;
}

int main() {
    for (uint64_t k = 2; k <= 10; k += 2) {
        std::cout << "Curzon numbers with base " << k << ":\n";
        uint64_t count = 0, n = 1;
        for (; count < 50; ++n) {
            if (is_curzon(n, k)) {
                std::cout << std::setw(4) << n
                          << (++count % 10 == 0 ? '\n' : ' ');
            }
        }
        for (;;) {
            if (is_curzon(n, k))
                ++count;
            if (count == 1000)
                break;
            ++n;
        }
        std::cout << "1000th Curzon number with base " << k << ": " << n
                  << "\n\n";
    }
    return 0;
}
