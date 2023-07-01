#include <iomanip>
#include <iostream>
#include <numeric>
#include <sstream>

bool duffinian(int n) {
    if (n == 2)
        return false;
    int total = 1, power = 2, m = n;
    for (; (n & 1) == 0; power <<= 1, n >>= 1)
        total += power;
    for (int p = 3; p * p <= n; p += 2) {
        int sum = 1;
        for (power = p; n % p == 0; power *= p, n /= p)
            sum += power;
        total *= sum;
    }
    if (m == n)
        return false;
    if (n > 1)
        total *= n + 1;
    return std::gcd(total, m) == 1;
}

int main() {
    std::cout << "First 50 Duffinian numbers:\n";
    for (int n = 1, count = 0; count < 50; ++n) {
        if (duffinian(n))
            std::cout << std::setw(3) << n << (++count % 10 == 0 ? '\n' : ' ');
    }
    std::cout << "\nFirst 50 Duffinian triplets:\n";
    for (int n = 1, m = 0, count = 0; count < 50; ++n) {
        if (duffinian(n))
            ++m;
        else
            m = 0;
        if (m == 3) {
            std::ostringstream os;
            os << '(' << n - 2 << ", " << n - 1 << ", " << n << ')';
            std::cout << std::left << std::setw(24) << os.str()
                      << (++count % 3 == 0 ? '\n' : ' ');
        }
    }
    std::cout << '\n';
}
