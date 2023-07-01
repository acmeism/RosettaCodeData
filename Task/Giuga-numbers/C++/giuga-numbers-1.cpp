#include <iostream>

// Assumes n is even with exactly one factor of 2.
bool is_giuga(unsigned int n) {
    unsigned int m = n / 2;
    auto test_factor = [&m, n](unsigned int p) -> bool {
        if (m % p != 0)
            return true;
        m /= p;
        return m % p != 0 && (n / p - 1) % p == 0;
    };
    if (!test_factor(3) || !test_factor(5))
        return false;
    static constexpr unsigned int wheel[] = {4, 2, 4, 2, 4, 6, 2, 6};
    for (unsigned int p = 7, i = 0; p * p <= m; ++i) {
        if (!test_factor(p))
            return false;
        p += wheel[i & 7];
    }
    return m == 1 || (n / m - 1) % m == 0;
}

int main() {
    std::cout << "First 5 Giuga numbers:\n";
    // n can't be 2 or divisible by 4
    for (unsigned int i = 0, n = 6; i < 5; n += 4) {
        if (is_giuga(n)) {
            std::cout << n << '\n';
            ++i;
        }
    }
}
