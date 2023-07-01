#include <algorithm>
#include <iostream>
#include <sstream>
#include <string>

template <typename T>
void demo_compare(const T &a, const T &b, const std::string &semantically) {
    std::cout << a << " and " << b << " are " << ((a == b) ? "" : "not ")
              << "exactly " << semantically << " equal." << std::endl;

    std::cout << a << " and " << b << " are " << ((a != b) ? "" : "not ")
              << semantically << "inequal." << std::endl;

    std::cout << a << " is " << ((a < b) ? "" : "not ") << semantically
              << " ordered before " << b << '.' << std::endl;

    std::cout << a << " is " << ((a > b) ? "" : "not ") << semantically
              << " ordered after " << b << '.' << std::endl;
}

int main(int argc, char *argv[]) {
    // Case-sensitive comparisons.
    std::string a((argc > 1) ? argv[1] : "1.2.Foo");
    std::string b((argc > 2) ? argv[2] : "1.3.Bar");
    demo_compare<std::string>(a, b, "lexically");

    // Case-insensitive comparisons by folding both strings to a common case.
    std::transform(a.begin(), a.end(), a.begin(), ::tolower);
    std::transform(b.begin(), b.end(), b.begin(), ::tolower);
    demo_compare<std::string>(a, b, "lexically");

    // Numeric comparisons; here 'double' could be any type for which the
    // relevant >> operator is defined, eg int, long, etc.
    double numA, numB;
    std::istringstream(a) >> numA;
    std::istringstream(b) >> numB;
    demo_compare<double>(numA, numB, "numerically");
    return (a == b);
}
