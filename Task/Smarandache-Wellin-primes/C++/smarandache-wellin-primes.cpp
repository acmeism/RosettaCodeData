#include <iomanip>
#include <iostream>
#include <string>

#include <primesieve.hpp>

#include <gmpxx.h>

using big_int = mpz_class;

class sw_number_generator {
public:
    sw_number_generator() { next(); }
    void next();
    const std::string& number() const { return number_; }
    uint64_t prime() const { return prime_; }
    int index() const { return index_; }
    std::string derived_number() const;

private:
    primesieve::iterator pi_;
    std::string number_;
    uint64_t prime_;
    int index_ = 0;
};

void sw_number_generator::next() {
    ++index_;
    prime_ = pi_.next_prime();
    number_ += std::to_string(prime_);
}

std::string sw_number_generator::derived_number() const {
    int count[10] = {};
    for (char c : number_)
        ++count[c - '0'];
    std::string str;
    for (int i = 0; i < 10; ++i) {
        if (!str.empty() || count[i] != 0)
            str += std::to_string(count[i]);
    }
    return str;
}

bool is_probably_prime(const big_int& n) {
    return mpz_probab_prime_p(n.get_mpz_t(), 25) != 0;
}

std::string abbreviate(std::string str, size_t max_digits) {
    size_t len = str.size();
    if (len > max_digits)
        str.replace(max_digits / 2, len - max_digits, "...");
    return str;
}

void print_sw_primes() {
    std::cout
        << "Known Smarandache-Wellin primes:\n\n"
        << "  |Index|Digits|Last prime|         Smarandache-Wellin prime\n"
        << "----------------------------------------------------------------------\n";
    sw_number_generator swg;
    for (int n = 1; n <= 8; swg.next()) {
        std::string num = swg.number();
        if (is_probably_prime(big_int(num))) {
            std::cout << std::setw(2) << n << "|"
                      << std::setw(5) << swg.index() << "|"
                      << std::setw(6) << num.size() << "|"
                      << std::setw(10) << swg.prime() << "|"
                      << std::setw(43) << abbreviate(num, 40) << '\n';
            ++n;
        }
    }
}

void print_derived_sw_primes(int count) {
    std::cout << "First " << count << " Derived Smarandache-Wellin primes:\n\n"
              << "  |Index|Derived Smarandache-Wellin prime\n"
              << "-----------------------------------------\n";
    sw_number_generator swg;
    for (int n = 1; n <= count; swg.next()) {
        std::string num = swg.derived_number();
        if (is_probably_prime(big_int(num))) {
            std::cout << std::setw(2) << n << "|"
                      << std::setw(5) << swg.index() << "|"
                      << std::setw(32) << num << '\n';
            ++n;
        }
    }
}

int main() {
    print_sw_primes();
    std::cout << '\n';
    print_derived_sw_primes(20);
}
