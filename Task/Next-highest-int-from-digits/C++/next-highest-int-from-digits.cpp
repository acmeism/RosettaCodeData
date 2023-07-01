#include <algorithm>
#include <iostream>
#include <sstream>

#include <gmpxx.h>

using integer = mpz_class;

std::string to_string(const integer& n) {
    std::ostringstream out;
    out << n;
    return out.str();
}

integer next_highest(const integer& n) {
    std::string str(to_string(n));
    if (!std::next_permutation(str.begin(), str.end()))
        return 0;
    return integer(str);
}

int main() {
    for (integer n : {0, 9, 12, 21, 12453, 738440, 45072010, 95322020})
        std::cout << n << " -> " << next_highest(n) << '\n';
    integer big("9589776899767587796600");
    std::cout << big << " -> " << next_highest(big) << '\n';
    return 0;
}
