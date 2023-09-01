#include <array>
#include <iostream>

#include <primesieve.hpp>

class ormiston_triple_generator {
public:
    ormiston_triple_generator() {
        for (int i = 0; i < 2; ++i) {
            primes_[i] = pi_.next_prime();
            digits_[i] = get_digits(primes_[i]);
        }
    }
    std::array<uint64_t, 3> next_triple() {
        for (;;) {
            uint64_t prime = pi_.next_prime();
            auto digits = get_digits(prime);
            bool is_triple = digits == digits_[0] && digits == digits_[1];
            uint64_t prime0 = primes_[0];
            primes_[0] = primes_[1];
            primes_[1] = prime;
            digits_[0] = digits_[1];
            digits_[1] = digits;
            if (is_triple)
                return {prime0, primes_[0], primes_[1]};
        }
    }

private:
    static std::array<int, 10> get_digits(uint64_t n) {
        std::array<int, 10> result = {};
        for (; n > 0; n /= 10)
            ++result[n % 10];
        return result;
    }
    primesieve::iterator pi_;
    std::array<uint64_t, 2> primes_;
    std::array<std::array<int, 10>, 2> digits_;
};

int main() {
    ormiston_triple_generator generator;
    int count = 0;
    std::cout << "Smallest members of first 25 Ormiston triples:\n";
    for (; count < 25; ++count) {
        auto primes = generator.next_triple();
        std::cout << primes[0] << ((count + 1) % 5 == 0 ? '\n' : ' ');
    }
    std::cout << '\n';
    for (uint64_t limit = 1000000000; limit <= 10000000000; ++count) {
        auto primes = generator.next_triple();
        if (primes[2] > limit) {
            std::cout << "Number of Ormiston triples < " << limit << ": "
                      << count << '\n';
            limit *= 10;
        }
    }
}
