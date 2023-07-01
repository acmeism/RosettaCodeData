#include <gmpxx.h>

#include <iomanip>
#include <iostream>

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

int main() {
    std::cout << "First 100 deceptive numbers:\n";
    mpz_class repunit = 11;
    for (int n = 3, count = 0; count != 100; n += 2) {
        if (n % 3 != 0 && n % 5 != 0 && !is_prime(n) &&
            mpz_divisible_ui_p(repunit.get_mpz_t(), n))
            std::cout << std::setw(6) << n << (++count % 10 == 0 ? '\n' : ' ');
        repunit *= 100;
        repunit += 11;
    }
}
