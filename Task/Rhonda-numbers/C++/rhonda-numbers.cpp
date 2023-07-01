#include <algorithm>
#include <cassert>
#include <iomanip>
#include <iostream>

int digit_product(int base, int n) {
    int product = 1;
    for (; n != 0; n /= base)
        product *= n % base;
    return product;
}

int prime_factor_sum(int n) {
    int sum = 0;
    for (; (n & 1) == 0; n >>= 1)
        sum += 2;
    for (int p = 3; p * p <= n; p += 2)
        for (; n % p == 0; n /= p)
            sum += p;
    if (n > 1)
        sum += n;
    return sum;
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

bool is_rhonda(int base, int n) {
    return digit_product(base, n) == base * prime_factor_sum(n);
}

std::string to_string(int base, int n) {
    assert(base <= 36);
    static constexpr char digits[] = "0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ";
    std::string str;
    for (; n != 0; n /= base)
        str += digits[n % base];
    std::reverse(str.begin(), str.end());
    return str;
}

int main() {
    const int limit = 15;
    for (int base = 2; base <= 36; ++base) {
        if (is_prime(base))
            continue;
        std::cout << "First " << limit << " Rhonda numbers to base " << base
                  << ":\n";
        int numbers[limit];
        for (int n = 1, count = 0; count < limit; ++n) {
            if (is_rhonda(base, n))
                numbers[count++] = n;
        }
        std::cout << "In base 10:";
        for (int i = 0; i < limit; ++i)
            std::cout << ' ' << numbers[i];
        std::cout << "\nIn base " << base << ':';
        for (int i = 0; i < limit; ++i)
            std::cout << ' ' << to_string(base, numbers[i]);
        std::cout << "\n\n";
    }
}
