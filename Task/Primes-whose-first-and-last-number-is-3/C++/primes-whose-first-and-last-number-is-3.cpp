#include <iomanip>
#include <iostream>

class number_generator {
public:
    explicit number_generator(int digit)
        : digit_(digit), last_(digit), number_(digit) {}
    int next();
private:
    int digit_;
    int power_ = 1;
    int last_;
    int number_;
};

int number_generator::next() {
    int result = number_;
    number_ += 10;
    if (number_ > last_) {
        number_ = digit_ + 10 * power_ * digit_;
        last_ = number_ + 10 * (power_ - 1);
        power_ *= 10;
    }
    return result;
}

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

int main() {
    std::cout.imbue(std::locale(""));
    for (int digit = 1; digit < 10; digit += 2) {
        std::cout << "Primes less than 10,000 that begin and end in " << digit
                  << ":\n";
        number_generator gen(digit);
        int n, count = 0;
        while ((n = gen.next()) < 1000000) {
            if (is_prime(n)) {
                ++count;
                if (n < 10000)
                    std::cout << std::setw(5) << n
                              << (count % 10 == 0 ? '\n' : ' ');
            }
        }
        std::cout << "\n\nNumber of such primes less than 1,000,000: " << count
                  << "\n\n";
    }
}
