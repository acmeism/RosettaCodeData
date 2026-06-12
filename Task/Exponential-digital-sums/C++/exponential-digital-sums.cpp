#include <iostream>
#include <vector>

#include <gmpxx.h>

using big_int = mpz_class;

int digit_sum(const big_int& n) {
    int sum = 0;
    for (char c : n.get_str())
        sum += c - '0';
    return sum;
}

void exp_digit_sums(int count, int min_ways, int max_power) {
    for (int i = 2; count > 0; ++i) {
        big_int n = i;
        std::vector<int> powers;
        for (int p = 2; p <= max_power; ++p) {
            n *= i;
            if (digit_sum(n) == i)
                powers.push_back(p);
        }
        if (powers.size() >= min_ways) {
            --count;
            auto it = powers.begin();
            std::cout << i << "^" << *it++;
            for (; it != powers.end(); ++it)
                std::cout << ", " << i << "^" << *it;
            std::cout << '\n';
        }
    }
}

int main() {
    std::cout << "First twenty-five integers that are equal to the digital sum "
                 "of that integer raised to some power:\n";
    exp_digit_sums(25, 1, 100);
    std::cout << "\nFirst thirty that satisfy that condition in three or more "
                 "ways:\n";
    exp_digit_sums(30, 3, 500);
}
