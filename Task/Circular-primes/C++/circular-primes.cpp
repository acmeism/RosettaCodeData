#include <cstdint>
#include <algorithm>
#include <iostream>
#include <sstream>
#include <gmpxx.h>

typedef mpz_class integer;

bool is_prime(const integer& n, int reps = 50) {
    return mpz_probab_prime_p(n.get_mpz_t(), reps);
}

std::string to_string(const integer& n) {
    std::ostringstream out;
    out << n;
    return out.str();
}

bool is_circular_prime(const integer& p) {
    if (!is_prime(p))
        return false;
    std::string str(to_string(p));
    for (size_t i = 0, n = str.size(); i + 1 < n; ++i) {
        std::rotate(str.begin(), str.begin() + 1, str.end());
        integer p2(str, 10);
        if (p2 < p || !is_prime(p2))
            return false;
    }
    return true;
}

integer next_repunit(const integer& n) {
    integer p = 1;
    while (p < n)
        p = 10 * p + 1;
    return p;
}

integer repunit(int digits) {
    std::string str(digits, '1');
    integer p(str);
    return p;
}

void test_repunit(int digits) {
    if (is_prime(repunit(digits), 10))
        std::cout << "R(" << digits << ") is probably prime\n";
    else
        std::cout << "R(" << digits << ") is not prime\n";
}

int main() {
    integer p = 2;
    std::cout << "First 19 circular primes:\n";
    for (int count = 0; count < 19; ++p) {
        if (is_circular_prime(p)) {
            if (count > 0)
                std::cout << ", ";
            std::cout << p;
            ++count;
        }
    }
    std::cout << '\n';
    std::cout << "Next 4 circular primes:\n";
    p = next_repunit(p);
    std::string str(to_string(p));
    int digits = str.size();
    for (int count = 0; count < 4; ) {
        if (is_prime(p, 15)) {
            if (count > 0)
                std::cout << ", ";
            std::cout << "R(" << digits << ")";
            ++count;
        }
        p = repunit(++digits);
    }
    std::cout << '\n';
    test_repunit(5003);
    test_repunit(9887);
    test_repunit(15073);
    test_repunit(25031);
    test_repunit(35317);
    test_repunit(49081);
    return 0;
}
