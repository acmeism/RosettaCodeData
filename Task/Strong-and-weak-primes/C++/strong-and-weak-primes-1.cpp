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
    prime_sieve sieve(limit2 + 100);

    // write numbers with groups of digits separated according to the system default locale
    std::cout.imbue(std::locale(""));

    // count and print strong/weak prime numbers
    prime_info strong_primes(36);
    prime_info weak_primes(37);
    int p1 = 2, p2 = 3;
    for (int p3 = 5; p2 < limit2; ++p3) {
        if (!sieve.is_prime(p3))
            continue;
        int diff = p1 + p3 - 2 * p2;
        if (diff < 0)
            strong_primes.add_prime(p2);
        else if (diff > 0)
            weak_primes.add_prime(p2);
        p1 = p2;
        p2 = p3;
    }
    strong_primes.print(std::cout, "strong");
    weak_primes.print(std::cout, "weak");
    return 0;
}
