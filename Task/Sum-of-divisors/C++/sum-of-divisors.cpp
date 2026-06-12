#include <iomanip>
#include <iostream>

// See https://en.wikipedia.org/wiki/Divisor_function
unsigned int divisor_sum(unsigned int n) {
    unsigned int total = 1, power = 2;
    // Deal with powers of 2 first
    for (; (n & 1) == 0; power <<= 1, n >>= 1)
        total += power;
    // Odd prime factors up to the square root
    for (unsigned int p = 3; p * p <= n; p += 2) {
        unsigned int sum = 1;
        for (power = p; n % p == 0; power *= p, n /= p)
            sum += power;
        total *= sum;
    }
    // If n > 1 then it's prime
    if (n > 1)
        total *= n + 1;
    return total;
}

int main() {
    const unsigned int limit = 100;
    std::cout << "Sum of divisors for the first " << limit << " positive integers:\n";
    for (unsigned int n = 1; n <= limit; ++n) {
        std::cout << std::setw(4) << divisor_sum(n);
        if (n % 10 == 0)
            std::cout << '\n';
    }
}
