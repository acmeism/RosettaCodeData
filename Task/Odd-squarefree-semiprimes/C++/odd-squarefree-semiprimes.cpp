#include <iomanip>
#include <iostream>

bool odd_square_free_semiprime(int n) {
    if ((n & 1) == 0)
        return false;
    int count = 0;
    for (int i = 3; i * i <= n; i += 2) {
        for (; n % i == 0; n /= i) {
            if (++count > 1)
                return false;
        }
    }
    return count == 1;
}

int main() {
    const int n = 1000;
    std::cout << "Odd square-free semiprimes < " << n << ":\n";
    int count = 0;
    for (int i = 1; i < n; i += 2) {
        if (odd_square_free_semiprime(i)) {
            ++count;
            std::cout << std::setw(4) << i;
            if (count % 20 == 0)
                std::cout << '\n';
        }
    }
    std::cout << "\nCount: " << count << '\n';
    return 0;
}
