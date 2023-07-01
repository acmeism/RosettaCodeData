#include <iomanip>
#include <iostream>
#include <vector>

std::vector<int> mertens_numbers(int max) {
    std::vector<int> m(max + 1, 1);
    for (int n = 2; n <= max; ++n) {
        for (int k = 2; k <= n; ++k)
            m[n] -= m[n / k];
    }
    return m;
}

int main() {
    const int max = 1000;
    auto m(mertens_numbers(max));
    std::cout << "First 199 Mertens numbers:\n";
    for (int i = 0, column = 0; i < 200; ++i) {
        if (column > 0)
            std::cout << ' ';
        if (i == 0)
            std::cout << "  ";
        else
            std::cout << std::setw(2) << m[i];
        ++column;
        if (column == 20) {
            std::cout << '\n';
            column = 0;
        }
    }
    int zero = 0, cross = 0, previous = 0;
    for (int i = 1; i <= max; ++i) {
        if (m[i] == 0) {
            ++zero;
            if (previous != 0)
                ++cross;
        }
        previous = m[i];
    }
    std::cout << "M(n) is zero " << zero << " times for 1 <= n <= 1000.\n";
    std::cout << "M(n) crosses zero " << cross << " times for 1 <= n <= 1000.\n";
    return 0;
}
