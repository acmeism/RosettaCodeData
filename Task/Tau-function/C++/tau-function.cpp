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
    std::cout << "Count of divisors for the first " << limit << " positive integers:\n";
    for (unsigned int n = 1; n <= limit; ++n) {
        std::cout << std::setw(3) << divisor_count(n);
        if (n % 20 == 0)
            std::cout << '\n';
    }
}
