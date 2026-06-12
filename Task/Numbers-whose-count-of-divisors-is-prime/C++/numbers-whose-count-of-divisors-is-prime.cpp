#include <cmath>
#include <cstdlib>
#include <iomanip>
#include <iostream>

int divisor_count(int n) {
    int total = 1;
    for (; (n & 1) == 0; n >>= 1)
        ++total;
    for (int p = 3; p * p <= n; p += 2) {
        int count = 1;
        for (; n % p == 0; n /= p)
            ++count;
        total *= count;
    }
    if (n > 1)
        total *= 2;
    return total;
}

bool is_prime(int n) {
    if (n < 2)
        return false;
    if (n % 2 == 0)
        return n == 2;
    if (n % 3 == 0)
        return n == 3;
    for (int p = 5; p * p <= n; p += 4) {
        if (n % p == 0)
            return false;
        p += 2;
        if (n % p == 0)
            return false;
    }
    return true;
}

int main(int argc, char** argv) {
    int limit = 1000;
    switch (argc) {
    case 1:
        break;
    case 2:
        limit = std::strtol(argv[1], nullptr, 10);
        if (limit <= 0) {
            std::cerr << "Invalid limit\n";
            return EXIT_FAILURE;
        }
        break;
    default:
        std::cerr << "usage: " << argv[0] << " [limit]\n";
        return EXIT_FAILURE;
    }
    int width = static_cast<int>(std::ceil(std::log10(limit)));
    int count = 0;
    for (int i = 1;; ++i) {
        int n = i * i;
        if (n >= limit)
            break;
        int divisors = divisor_count(n);
        if (divisors != 2 && is_prime(divisors))
            std::cout << std::setw(width) << n << (++count % 10 == 0 ? '\n' : ' ');
    }
    std::cout << "\nCount: " << count << '\n';
    return EXIT_SUCCESS;
}
