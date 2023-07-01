#include <iomanip>
#include <iostream>

unsigned int divisor_count(unsigned int n) {
    unsigned int total = 1;
    for (; (n & 1) == 0; n >>= 1)
        ++total;
    for (unsigned int p = 3; p * p <= n; p += 2) {
        unsigned int count = 1;
        for (; n % p == 0; n /= p)
            ++count;
        total *= count;
    }
    if (n > 1)
        total *= 2;
    return total;
}

int main() {
    std::cout.imbue(std::locale(""));
    std::cout << "First 50 numbers which are the cube roots of the products of "
                 "their proper divisors:\n";
    for (unsigned int n = 1, count = 0; count < 50000; ++n) {
        if (n == 1 || divisor_count(n) == 8) {
            ++count;
            if (count <= 50)
                std::cout << std::setw(3) << n
                          << (count % 10 == 0 ? '\n' : ' ');
            else if (count == 500 || count == 5000 || count == 50000)
                std::cout << std::setw(6) << count << "th: " << n << '\n';
        }
    }
}
