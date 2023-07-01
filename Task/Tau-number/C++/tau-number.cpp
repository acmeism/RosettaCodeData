#include <iomanip>
#include <iostream>

// See https://en.wikipedia.org/wiki/Divisor_function
unsigned int divisor_count(unsigned int n) {
    unsigned int total = 1;
    // Deal with powers of 2 first
    for (; (n & 1) == 0; n >>= 1)
        ++total;
    // Odd prime factors up to the square root
    for (unsigned int p = 3; p * p <= n; p += 2) {
        unsigned int count = 1;
        for (; n % p == 0; n /= p)
            ++count;
        total *= count;
    }
    // If n > 1 then it's prime
    if (n > 1)
        total *= 2;
    return total;
}

int main() {
    const unsigned int limit = 100;
    std::cout << "The first " << limit << " tau numbers are:\n";
    unsigned int count = 0;
    for (unsigned int n = 1; count < limit; ++n) {
        if (n % divisor_count(n) == 0) {
            std::cout << std::setw(6) << n;
            ++count;
            if (count % 10 == 0)
                std::cout << '\n';
        }
    }
}
