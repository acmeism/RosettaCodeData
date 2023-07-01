#include <iostream>
#include <vector>
#include <boost/rational.hpp>

using rational = boost::rational<unsigned long>;

unsigned long floor(const rational& r) {
    return r.numerator()/r.denominator();
}

rational calkin_wilf_next(const rational& term) {
    return 1UL/(2UL * floor(term) + 1UL - term);
}

std::vector<unsigned long> continued_fraction(const rational& r) {
    unsigned long a = r.numerator();
    unsigned long b = r.denominator();
    std::vector<unsigned long> result;
    do {
        result.push_back(a/b);
        unsigned long c = a;
        a = b;
        b = c % b;
    } while (a != 1);
    if (result.size() > 0 && result.size() % 2 == 0) {
        --result.back();
        result.push_back(1);
    }
    return result;
}

unsigned long term_number(const rational& r) {
    unsigned long result = 0;
    unsigned long d = 1;
    unsigned long p = 0;
    for (unsigned long n : continued_fraction(r)) {
        for (unsigned long i = 0; i < n; ++i, ++p)
            result |= (d << p);
        d = !d;
    }
    return result;
}

int main() {
    rational term = 1;
    std::cout << "First 20 terms of the Calkin-Wilf sequence are:\n";
    for (int i = 1; i <= 20; ++i) {
        std::cout << std::setw(2) << i << ": " << term << '\n';
        term = calkin_wilf_next(term);
    }
    rational r(83116, 51639);
    std::cout << r << " is the " << term_number(r) << "th term of the sequence.\n";
}
