#include <cassert>
#include <iomanip>
#include <iostream>

int largest_proper_divisor(int n) {
    assert(n > 0);
    if ((n & 1) == 0)
        return n >> 1;
    for (int p = 3; p * p <= n; p += 2) {
        if (n % p == 0)
            return n / p;
    }
    return 1;
}

int main() {
    for (int n = 1; n < 101; ++n) {
        std::cout << std::setw(2) << largest_proper_divisor(n)
            << (n % 10 == 0 ? '\n' : ' ');
    }
}
