#include <iomanip>
#include <iostream>

int digit_sum(int n) {
    int sum = 0;
    for (; n > 0; n /= 10)
        sum += n % 10;
    return sum;
}

int main() {
    for (int n = 1; n <= 70; ++n) {
        for (int m = 1;; ++m) {
            if (digit_sum(m * n) == n) {
                std::cout << std::setw(8) << m << (n % 10 == 0 ? '\n' : ' ');
                break;
            }
        }
    }
}
