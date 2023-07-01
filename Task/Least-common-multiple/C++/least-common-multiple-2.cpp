#include <cstdlib>
#include <iostream>
#include <tuple>

int gcd(int a, int b) {
    a = abs(a);
    b = abs(b);
    while (b != 0) {
        std::tie(a, b) = std::make_tuple(b, a % b);
    }
    return a;
}

int lcm(int a, int b) {
    int c = gcd(a, b);
    return c == 0 ? 0 : a / c * b;
}

int main() {
    std::cout << "The least common multiple of 12 and 18 is " << lcm(12, 18) << ",\n"
        << "and their greatest common divisor is " << gcd(12, 18) << "!"
        << std::endl;
    return 0;
}
