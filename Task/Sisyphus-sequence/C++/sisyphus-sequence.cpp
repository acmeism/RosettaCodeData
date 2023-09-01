#include <algorithm>
#include <iomanip>
#include <iostream>

#include <primesieve.hpp>

class sisyphus_iterator {
public:
    uint64_t next() {
        uint64_t n = next_;
        if (next_ % 2 == 0) {
            next_ /= 2;
        } else {
            prime_ = pi_.next_prime();
            next_ += prime_;
        }
        return n;
    }
    uint64_t prime() const { return prime_; }

private:
    primesieve::iterator pi_;
    uint64_t next_ = 1;
    uint64_t prime_ = 0;
};

int main() {
    std::cout.imbue(std::locale(""));
    sisyphus_iterator si;
    int found[250] = {};
    std::cout << "The first 100 members of the Sisyphus sequence are:\n";
    uint64_t count = 1;
    const uint64_t limit = 100000000;
    for (uint64_t n = 1000; n <= limit; ++count) {
        uint64_t next = si.next();
        if (next < 250)
            ++found[next];
        if (count <= 100) {
            std::cout << std::setw(3) << next << (count % 10 == 0 ? '\n' : ' ');
            if (count == 100)
                std::cout << '\n';
        } else if (count == n) {
            std::cout << std::setw(11) << n << "th member is " << std::setw(13)
                      << next << " and highest prime needed is "
                      << std::setw(11) << si.prime() << '\n';
            n *= 10;
        }
    }
    auto f = [&found](int n) {
        bool first = true;
        for (int i = 1; i < 250; ++i) {
            if (found[i] == n) {
                if (first)
                    first = false;
                else
                    std::cout << ", ";
                std::cout << i;
            }
        }
    };
    std::cout << "\nThese numbers under 250 do not occur in the first " << limit
              << " terms:\n";
    f(0);
    int max = *std::max_element(std::begin(found), std::end(found));
    std::cout << "\n\nThese numbers under 250 occur the most in the first "
              << limit << " terms:\n";
    f(max);
    std::cout << " all occur " << max << " times.\n\n";
    for (;; ++count) {
        uint64_t next = si.next();
        if (next == 36) {
            std::cout << count << "th member is " << 36
                      << " and highest prime needed is " << si.prime() << '\n';
            break;
        }
    }
}
