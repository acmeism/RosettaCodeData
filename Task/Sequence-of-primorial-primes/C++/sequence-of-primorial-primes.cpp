#include <cstdint>
#include <iostream>
#include <sstream>
#include <gmpxx.h>

typedef mpz_class integer;

bool is_probably_prime(const integer& n) {
    return mpz_probab_prime_p(n.get_mpz_t(), 25) != 0;
}

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
    const unsigned int max = 20;
    integer primorial = 1;
    for (unsigned int p = 0, count = 0, index = 0; count < max; ++p) {
        if (!is_prime(p))
            continue;
        primorial *= p;
        ++index;
        if (is_probably_prime(primorial - 1) || is_probably_prime(primorial + 1)) {
            if (count > 0)
                std::cout << ' ';
            std::cout << index;
            ++count;
        }
    }
    std::cout << '\n';
    return 0;
}
