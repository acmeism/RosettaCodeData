#include <iomanip>
#include <iostream>

#include <gmpxx.h>

using big_int = mpz_class;

class riordan_number_generator {
public:
    big_int next();

private:
    big_int a0_ = 1;
    big_int a1_ = 0;
    int n_ = 0;
};

big_int riordan_number_generator::next() {
    int n = n_++;
    if (n == 0)
        return a0_;
    if (n == 1)
        return a1_;
    big_int a = (n - 1) * (2 * a1_ + 3 * a0_) / (n + 1);
    a0_ = a1_;
    a1_ = a;
    return a;
}

std::string to_string(const big_int& num, size_t max_digits) {
    std::string str = num.get_str();
    size_t len = str.size();
    if (len > max_digits)
        str.replace(max_digits / 2, len - max_digits, "...");
    return str;
}

int main() {
    riordan_number_generator rng;
    std::cout << "First 32 Riordan numbers:\n";
    int i = 1;
    for (; i <= 32; ++i) {
        std::cout << std::setw(14) << rng.next()
                  << (i % 4 == 0 ? '\n' : ' ');
    }
    for (; i < 1000; ++i)
        rng.next();
    auto num = rng.next();
    ++i;
    std::cout << "\nThe 1000th is " << to_string(num, 40) << " ("
              << num.get_str().size() << " digits).\n";
    for (; i < 10000; ++i)
        rng.next();
    num = rng.next();
    std::cout << "The 10000th is " << to_string(num, 40) << " ("
              << num.get_str().size() << " digits).\n";
}
