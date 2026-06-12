#include <iomanip>
#include <iostream>

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

bool is_depolignac_number(int n) {
    for (int p = 1; p < n; p <<= 1) {
        if (is_prime(n - p))
            return false;
    }
    return true;
}

int main() {
    std::cout.imbue(std::locale(""));
    std::cout << "First 50 de Polignac numbers:\n";
    for (int n = 1, count = 0; count < 10000; n += 2) {
        if (is_depolignac_number(n)) {
            ++count;
            if (count <= 50)
                std::cout << std::setw(5) << n
                          << (count % 10 == 0 ? '\n' : ' ');
            else if (count == 1000)
                std::cout << "\nOne thousandth: " << n << '\n';
            else if (count == 10000)
                std::cout << "\nTen thousandth: " << n << '\n';
        }
    }
}
