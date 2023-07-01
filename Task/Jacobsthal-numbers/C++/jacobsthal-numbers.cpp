#include <gmpxx.h>

#include <iomanip>
#include <iostream>

using big_int = mpz_class;

bool is_probably_prime(const big_int& n) {
    return mpz_probab_prime_p(n.get_mpz_t(), 30) != 0;
}

big_int jacobsthal_number(unsigned int n) {
    return ((big_int(1) << n) - (n % 2 == 0 ? 1 : -1)) / 3;
}

big_int jacobsthal_lucas_number(unsigned int n) {
    return (big_int(1) << n) + (n % 2 == 0 ? 1 : -1);
}

big_int jacobsthal_oblong_number(unsigned int n) {
    return jacobsthal_number(n) * jacobsthal_number(n + 1);
}

int main() {
    std::cout << "First 30 Jacobsthal Numbers:\n";
    for (unsigned int n = 0; n < 30; ++n) {
        std::cout << std::setw(9) << jacobsthal_number(n)
                  << ((n + 1) % 5 == 0 ? '\n' : ' ');
    }
    std::cout << "\nFirst 30 Jacobsthal-Lucas Numbers:\n";
    for (unsigned int n = 0; n < 30; ++n) {
        std::cout << std::setw(9) << jacobsthal_lucas_number(n)
                  << ((n + 1) % 5 == 0 ? '\n' : ' ');
    }
    std::cout << "\nFirst 20 Jacobsthal oblong Numbers:\n";
    for (unsigned int n = 0; n < 20; ++n) {
        std::cout << std::setw(11) << jacobsthal_oblong_number(n)
                  << ((n + 1) % 5 == 0 ? '\n' : ' ');
    }
    std::cout << "\nFirst 20 Jacobsthal primes:\n";
    for (unsigned int n = 0, count = 0; count < 20; ++n) {
        auto jn = jacobsthal_number(n);
        if (is_probably_prime(jn)) {
            ++count;
            std::cout << jn << '\n';
        }
    }
}
