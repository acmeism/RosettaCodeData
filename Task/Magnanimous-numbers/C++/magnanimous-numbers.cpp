#include <iomanip>
#include <iostream>

bool is_prime(unsigned int n) {
    if (n < 2)
        return false;
    if (n % 2 == 0)
        return n == 2;
    if (n % 3 == 0)
        return n == 3;
    for (unsigned int p = 5; p * p <= n; p += 4) {
        if (n % p == 0)
            return false;
        p += 2;
        if (n % p == 0)
            return false;
    }
    return true;
}

bool is_magnanimous(unsigned int n) {
    for (unsigned int p = 10; n >= p; p *= 10) {
        if (!is_prime(n % p + n / p))
            return false;
    }
    return true;
}

int main() {
    unsigned int count = 0, n = 0;
    std::cout << "First 45 magnanimous numbers:\n";
    for (; count < 45; ++n) {
        if (is_magnanimous(n)) {
            if (count > 0)
                std::cout << (count % 15 == 0 ? "\n" : ", ");
            std::cout << std::setw(3) << n;
            ++count;
        }
    }
    std::cout << "\n\n241st through 250th magnanimous numbers:\n";
    for (unsigned int i = 0; count < 250; ++n) {
        if (is_magnanimous(n)) {
            if (count++ >= 240) {
                if (i++ > 0)
                    std::cout << ", ";
                std::cout << n;
            }
        }
    }
    std::cout << "\n\n391st through 400th magnanimous numbers:\n";
    for (unsigned int i = 0; count < 400; ++n) {
        if (is_magnanimous(n)) {
            if (count++ >= 390) {
                if (i++ > 0)
                    std::cout << ", ";
                std::cout << n;
            }
        }
    }
    std::cout << '\n';
    return 0;
}
