#include <array>
#include <iostream>

using digits = std::array<unsigned int, 10>;

digits get_digits(unsigned int n) {
    digits d = {};
    do {
        ++d[n % 10];
        n /= 10;
    } while (n > 0);
    return d;
}

// Returns true if n, 2n, ..., 6n all have the same base 10 digits.
bool same_digits(unsigned int n) {
    digits d = get_digits(n);
    for (unsigned int i = 0, m = n; i < 5; ++i) {
        m += n;
        if (get_digits(m) != d)
            return false;
    }
    return true;
}

int main() {
    for (unsigned int p = 100; ; p *= 10) {
        unsigned int max = (p * 10) / 6;
        for (unsigned int n = p + 2; n <= max; n += 3) {
            if (same_digits(n)) {
                std::cout << " n = " << n << '\n';
                for (unsigned int i = 2; i <= 6; ++i)
                    std::cout << i << "n = " << n * i << '\n';
                return 0;
            }
        }
    }
}
