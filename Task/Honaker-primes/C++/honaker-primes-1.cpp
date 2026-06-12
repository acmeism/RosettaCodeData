#include <iomanip>
#include <iostream>
#include <sstream>
#include <utility>

#include <primesieve.hpp>

uint64_t digit_sum(uint64_t n) {
    uint64_t sum = 0;
    for (; n > 0; n /= 10)
        sum += n % 10;
    return sum;
}

class honaker_prime_generator {
public:
    std::pair<uint64_t, uint64_t> next();

private:
    primesieve::iterator pi_;
    uint64_t index_ = 0;
};

std::pair<uint64_t, uint64_t> honaker_prime_generator::next() {
    for (;;) {
        uint64_t prime = pi_.next_prime();
        ++index_;
        if (digit_sum(index_) == digit_sum(prime))
            return std::make_pair(index_, prime);
    }
}

std::ostream& operator<<(std::ostream& os,
                         const std::pair<uint64_t, uint64_t>& p) {
    std::ostringstream str;
    str << '(' << p.first << ", " << p.second << ')';
    return os << str.str();
}

int main() {
    honaker_prime_generator hpg;
    std::cout << "First 50 Honaker primes (index, prime):\n";
    int i = 1;
    for (; i <= 50; ++i)
        std::cout << std::setw(11) << hpg.next() << (i % 5 == 0 ? '\n' : ' ');
    for (; i < 10000; ++i)
        hpg.next();
    std::cout << "\nTen thousandth: " << hpg.next() << '\n';
}
