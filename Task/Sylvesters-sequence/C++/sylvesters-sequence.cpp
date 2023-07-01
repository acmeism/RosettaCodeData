#include <iomanip>
#include <iostream>
#include <boost/rational.hpp>
#include <boost/multiprecision/cpp_int.hpp>

using integer = boost::multiprecision::cpp_int;
using rational = boost::rational<integer>;

integer sylvester_next(const integer& n) {
    return n * n - n + 1;
}

int main() {
    std::cout << "First 10 elements in Sylvester's sequence:\n";
    integer term = 2;
    rational sum = 0;
    for (int i = 1; i <= 10; ++i) {
        std::cout << std::setw(2) << i << ": " << term << '\n';
        sum += rational(1, term);
        term = sylvester_next(term);
    }
    std::cout << "Sum of reciprocals: " << sum << '\n';
}
