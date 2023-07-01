#include <iostream>

bool gapful(int n) {
    int m = n;
    while (m >= 10)
        m /= 10;
    return n % ((n % 10) + 10 * (m % 10)) == 0;
}

void show_gapful_numbers(int n, int count) {
    std::cout << "First " << count << " gapful numbers >= " << n << ":\n";
    for (int i = 0; i < count; ++n) {
        if (gapful(n)) {
            if (i != 0)
                std::cout << ", ";
            std::cout << n;
            ++i;
        }
    }
    std::cout << '\n';
}

int main() {
    show_gapful_numbers(100, 30);
    show_gapful_numbers(1000000, 15);
    show_gapful_numbers(1000000000, 10);
    return 0;
}
