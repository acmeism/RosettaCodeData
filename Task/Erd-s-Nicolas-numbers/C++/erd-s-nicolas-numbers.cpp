#include <iomanip>
#include <iostream>
#include <vector>

int main() {
    const int max_number = 100000000;
    std::vector<int> dsum(max_number + 1, 1);
    std::vector<int> dcount(max_number + 1, 1);
    for (int i = 2; i <= max_number; ++i) {
        for (int j = i + i; j <= max_number; j += i) {
            if (dsum[j] == j) {
                std::cout << std::setw(8) << j
                          << " equals the sum of its first " << dcount[j]
                          << " divisors\n";
            }
            dsum[j] += i;
            ++dcount[j];
        }
    }
}
