#include <iostream>
#include <locale>

#include <primesieve.hpp>

int main() {
    std::cout.imbue(std::locale(""));
    const uint64_t limit = 10000000000;
    uint64_t max_diff = 0;
    primesieve::iterator pi;
    uint64_t p1 = pi.next_prime();
    for (uint64_t p = 10;;) {
        uint64_t p2 = pi.next_prime();
        if (p2 >= p) {
            std::cout << "Largest gap between primes under " << p << " is "
                      << max_diff << ".\n";
            if (p == limit)
                break;
            p *= 10;
        }
        if (p2 - p1 > max_diff)
            max_diff = p2 - p1;
        p1 = p2;
    }
}
