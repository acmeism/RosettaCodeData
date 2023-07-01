#include <iomanip>
#include <iostream>

int factorial_mod(int n, int p) {
    int f = 1;
    for (; n > 0 && f != 0; --n)
        f = (f * n) % p;
    return f;
}

bool is_prime(int p) {
    return p > 1 && factorial_mod(p - 1, p) == p - 1;
}

int main() {
    std::cout << "  n | prime?\n------------\n";
    std::cout << std::boolalpha;
    for (int p : {2, 3, 9, 15, 29, 37, 47, 57, 67, 77, 87, 97, 237, 409, 659})
        std::cout << std::setw(3) << p << " | " << is_prime(p) << '\n';

    std::cout << "\nFirst 120 primes by Wilson's theorem:\n";
    int n = 0, p = 1;
    for (; n < 120; ++p) {
        if (is_prime(p))
            std::cout << std::setw(3) << p << (++n % 20 == 0 ? '\n' : ' ');
    }

    std::cout << "\n1000th through 1015th primes:\n";
    for (int i = 0; n < 1015; ++p) {
        if (is_prime(p)) {
            if (++n >= 1000)
                std::cout << std::setw(4) << p << (++i % 16 == 0 ? '\n' : ' ');
        }
    }
}
