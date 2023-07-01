#include <algorithm>
#include <iostream>
#include <iterator>
#include <locale>
#include <vector>
#include "prime_sieve.hpp"

const int limit1 = 1000000;
const int limit2 = 10000000;

class prime_info {
public:
    explicit prime_info(int max) : max_print(max) {}
    void add_prime(int prime);
    void print(std::ostream& os, const char* name) const;
private:
    int max_print;
    int count1 = 0;
    int count2 = 0;
    std::vector<int> primes;
};

void prime_info::add_prime(int prime) {
    ++count2;
    if (prime < limit1)
        ++count1;
    if (count2 <= max_print)
        primes.push_back(prime);
}

void prime_info::print(std::ostream& os, const char* name) const {
    os << "First " << max_print << " " << name << " primes: ";
    std::copy(primes.begin(), primes.end(), std::ostream_iterator<int>(os, " "));
    os << '\n';
    os << "Number of " << name << " primes below " << limit1 << ": " << count1 << '\n';
    os << "Number of " << name << " primes below " << limit2 << ": " << count2 << '\n';
}

int main() {
    // find the prime numbers up to limit2
    prime_sieve sieve(limit2);

    // write numbers with groups of digits separated according to the system default locale
    std::cout.imbue(std::locale(""));

    // count and print safe/unsafe prime numbers
    prime_info safe_primes(35);
    prime_info unsafe_primes(40);
    for (int p = 2; p < limit2; ++p) {
        if (sieve.is_prime(p)) {
            if (sieve.is_prime((p - 1)/2))
                safe_primes.add_prime(p);
            else
                unsafe_primes.add_prime(p);
        }
    }
    safe_primes.print(std::cout, "safe");
    unsafe_primes.print(std::cout, "unsafe");
    return 0;
}
