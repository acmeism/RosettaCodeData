#include <gmpxx.h>
#include <primesieve.hpp>

#include <cstdint>
#include <iomanip>
#include <iostream>

size_t digits(const mpz_class& n) { return n.get_str().length(); }

mpz_class primorial(unsigned int n) {
    mpz_class p;
    mpz_primorial_ui(p.get_mpz_t(), n);
    return p;
}

int main() {
    uint64_t index = 0;
    primesieve::iterator pi;
    std::cout << "First 10 primorial numbers:\n";
    for (mpz_class pn = 1; index < 10; ++index) {
        unsigned int prime = pi.next_prime();
        std::cout << index << ": " << pn << '\n';
        pn *= prime;
    }
    std::cout << "\nLength of primorial number whose index is:\n";
    for (uint64_t power = 10; power <= 1000000; power *= 10) {
        uint64_t prime = primesieve::nth_prime(power);
        std::cout << std::setw(7) << power << ": "
                  << digits(primorial(prime)) << '\n';
    }
    return 0;
}
