#include <chrono>
#include <iostream>
#include <utility>
#include <primesieve.hpp>
#include <gmpxx.h>

using big_int = mpz_class;

bool is_probably_prime(const big_int& n) {
    return mpz_probab_prime_p(n.get_mpz_t(), 30) != 0;
}

class prime_fibonacci_generator {
public:
    prime_fibonacci_generator();
    std::pair<uint64_t, big_int> next();
private:
    big_int next_fibonacci();
    primesieve::iterator p_;
    big_int f0_ = 0;
    big_int f1_ = 1;
    uint64_t n_ = 0;
};

prime_fibonacci_generator::prime_fibonacci_generator() {
    for (int i = 0; i < 2; ++i)
        p_.next_prime();
}

std::pair<uint64_t, big_int> prime_fibonacci_generator::next() {
    for (;;) {
        if (n_ > 4) {
            uint64_t p = p_.next_prime();
            for (; p > n_; ++n_)
                next_fibonacci();
        }
        ++n_;
        big_int f = next_fibonacci();
        if (is_probably_prime(f))
            return {n_ - 1, f};
    }
}

big_int prime_fibonacci_generator::next_fibonacci() {
    big_int result = f0_;
    big_int f = f0_ + f1_;
    f0_ = f1_;
    f1_ = f;
    return result;
}

std::string to_string(const big_int& n) {
    std::string str = n.get_str();
    size_t len = str.size();
    if (len > 40) {
        str.replace(20, len - 40, "...");
        str += " (";
        str += std::to_string(len);
        str += " digits)";
    }
    return str;
}

int main() {
    auto start = std::chrono::high_resolution_clock::now();
    prime_fibonacci_generator gen;
    for (int i = 1; i <= 26; ++i) {
        auto [n, f] = gen.next();
        std::cout << i << ": F(" << n << ") = " << to_string(f) << '\n';
    }
    auto finish = std::chrono::high_resolution_clock::now();
    std::chrono::duration<double> ms(finish - start);
    std::cout << "elapsed time: " << ms.count() << " seconds\n";
}
