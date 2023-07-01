#include <future>
#include <iomanip>
#include <iostream>
#include <vector>

#include <gmpxx.h>
#include <primesieve.hpp>

std::vector<uint64_t> repunit_primes(uint32_t base,
                                     const std::vector<uint64_t>& primes) {
    std::vector<uint64_t> result;
    for (uint64_t prime : primes) {
        mpz_class repunit(std::string(prime, '1'), base);
        if (mpz_probab_prime_p(repunit.get_mpz_t(), 25) != 0)
            result.push_back(prime);
    }
    return result;
}

int main() {
    std::vector<uint64_t> primes;
    const uint64_t limit = 2700;
    primesieve::generate_primes(limit, &primes);
    std::vector<std::future<std::vector<uint64_t>>> futures;
    for (uint32_t base = 2; base <= 36; ++base) {
        futures.push_back(std::async(repunit_primes, base, primes));
    }
    std::cout << "Repunit prime digits (up to " << limit << ") in:\n";
    for (uint32_t base = 2, i = 0; base <= 36; ++base, ++i) {
        std::cout << "Base " << std::setw(2) << base << ':';
        for (auto digits : futures[i].get())
            std::cout << ' ' << digits;
        std::cout << '\n';
    }
}
