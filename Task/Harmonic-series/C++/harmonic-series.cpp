#include <iomanip>
#include <iostream>
#include <boost/rational.hpp>
#include <boost/multiprecision/gmp.hpp>

using integer = boost::multiprecision::mpz_int;
using rational = boost::rational<integer>;

class harmonic_generator {
public:
    rational next() {
        rational result = term_;
        term_ += rational(1, ++n_);
        return result;
    }
    void reset() {
        n_ = 1;
        term_ = 1;
    }
private:
    integer n_ = 1;
    rational term_ = 1;
};

int main() {
    std::cout << "First 20 harmonic numbers:\n";
    harmonic_generator hgen;
    for (int i = 1; i <= 20; ++i)
        std::cout << std::setw(2) << i << ". " << hgen.next() << '\n';

    rational h;
    for (int i = 1; i <= 80; ++i)
        h = hgen.next();
    std::cout << "\n100th harmonic number: " << h << "\n\n";

    int n = 1;
    hgen.reset();
    for (int i = 1; n <= 10; ++i) {
        if (hgen.next() > n)
            std::cout << "Position of first term > " << std::setw(2) << n++ << ": " << i << '\n';
    }
}
