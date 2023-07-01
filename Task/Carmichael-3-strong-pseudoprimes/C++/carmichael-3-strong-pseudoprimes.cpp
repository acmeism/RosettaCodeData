#include <iomanip>
#include <iostream>

int mod(int n, int d) {
    return (d + n % d) % d;
}

bool is_prime(int n) {
    if (n < 2)
        return false;
    if (n % 2 == 0)
        return n == 2;
    if (n % 3 == 0)
        return n == 3;
    for (int p = 5; p * p <= n; p += 4) {
        if (n % p == 0)
            return false;
        p += 2;
        if (n % p == 0)
            return false;
    }
    return true;
}

void print_carmichael_numbers(int prime1) {
    for (int h3 = 1; h3 < prime1; ++h3) {
        for (int d = 1; d < h3 + prime1; ++d) {
            if (mod((h3 + prime1) * (prime1 - 1), d) != 0
                || mod(-prime1 * prime1, h3) != mod(d, h3))
                continue;
            int prime2 = 1 + (prime1 - 1) * (h3 + prime1)/d;
            if (!is_prime(prime2))
                continue;
            int prime3 = 1 + prime1 * prime2/h3;
            if (!is_prime(prime3))
                continue;
            if (mod(prime2 * prime3, prime1 - 1) != 1)
                continue;
            unsigned int c = prime1 * prime2 * prime3;
            std::cout << std::setw(2) << prime1 << " x "
                << std::setw(4) << prime2 << " x "
                << std::setw(5) << prime3 << " = "
                << std::setw(10) << c << '\n';
        }
    }
}

int main() {
    for (int p = 2; p <= 61; ++p) {
        if (is_prime(p))
            print_carmichael_numbers(p);
    }
    return 0;
}
