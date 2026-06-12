#include <iomanip>
#include <iostream>

bool is_prime(unsigned int n) {
    if (n < 2)
        return false;
    if (n % 2 == 0)
        return n == 2;
    if (n % 3 == 0)
        return n == 3;
    for (unsigned int p = 5; p * p <= n; p += 4) {
        if (n % p == 0)
            return false;
        p += 2;
        if (n % p == 0)
            return false;
    }
    return true;
}

int main() {
    for (unsigned int n = 1; n < 200; n += 2) {
        auto p = n * n * n + 2;
        if (is_prime(p))
            std::cout << std::setw(3) << n << std::setw(9) << p << '\n';
    }
}
