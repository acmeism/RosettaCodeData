#include <cassert>
#include <iomanip>
#include <iostream>
#include <string>

#include <gmpxx.h>

using big_int = mpz_class;

auto juggler(int n) {
    assert(n >= 1);
    int count = 0, max_count = 0;
    big_int a = n, max = n;
    while (a != 1) {
        if (a % 2 == 0)
            a = sqrt(a);
        else
            a = sqrt(big_int(a * a * a));
        ++count;
        if (a > max) {
            max = a;
            max_count = count;
        }
    }
    return std::make_tuple(count, max_count, max, max.get_str().size());
}

int main() {
    std::cout.imbue(std::locale(""));
    std::cout << "n    l[n]  i[n]   h[n]\n";
    std::cout << "--------------------------------\n";
    for (int n = 20; n < 40; ++n) {
        auto [count, max_count, max, digits] = juggler(n);
        std::cout << std::setw(2) << n << "    " << std::setw(2) << count
                  << "    " << std::setw(2) << max_count << "    " << max
                  << '\n';
    }
    std::cout << '\n';
    std::cout << "       n       l[n]   i[n]   d[n]\n";
    std::cout << "----------------------------------------\n";
    for (int n : {113, 173, 193, 2183, 11229, 15065, 15845, 30817, 48443,
                  275485, 1267909, 2264915, 5812827, 7110201, 56261531,
                  92502777, 172376627, 604398963}) {
        auto [count, max_count, max, digits] = juggler(n);
        std::cout << std::setw(11) << n << "    " << std::setw(3) << count
                  << "    " << std::setw(3) << max_count << "    " << digits
                  << '\n';
    }
}
