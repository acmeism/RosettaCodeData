#include <cstdint>
#include <iomanip>
#include <iostream>
#include <set>
#include <primesieve.hpp>

class erdos_prime_generator {
public:
    erdos_prime_generator() {}
    uint64_t next();
private:
    bool erdos(uint64_t p) const;
    primesieve::iterator iter_;
    std::set<uint64_t> primes_;
};

uint64_t erdos_prime_generator::next() {
    uint64_t prime;
    for (;;) {
        prime = iter_.next_prime();
        primes_.insert(prime);
        if (erdos(prime))
            break;
    }
    return prime;
}

bool erdos_prime_generator::erdos(uint64_t p) const {
    for (uint64_t k = 1, f = 1; f < p; ++k, f *= k) {
        if (primes_.find(p - f) != primes_.end())
            return false;
    }
    return true;
}

int main() {
    std::wcout.imbue(std::locale(""));
    erdos_prime_generator epgen;
    const int max_print = 2500;
    const int max_count = 7875;
    uint64_t p;
    std::wcout << L"Erd\x151s primes less than " << max_print << L":\n";
    for (int count = 1; count <= max_count; ++count) {
        p = epgen.next();
        if (p < max_print)
            std::wcout << std::setw(6) << p << (count % 10 == 0 ? '\n' : ' ');
    }
    std::wcout << L"\n\nThe " << max_count << L"th Erd\x151s prime is " << p << L".\n";
    return 0;
}
