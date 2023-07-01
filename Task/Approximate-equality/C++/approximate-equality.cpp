#include <iomanip>
#include <iostream>
#include <cmath>

bool approxEquals(double a, double b, double e) {
    return fabs(a - b) < e;
}

void test(double a, double b) {
    constexpr double epsilon = 1e-18;
    std::cout << std::setprecision(21) << a;
    std::cout << ", ";
    std::cout << std::setprecision(21) << b;
    std::cout << " => ";
    std::cout << approxEquals(a, b, epsilon) << '\n';
}

int main() {
    test(100000000000000.01, 100000000000000.011);
    test(100.01, 100.011);
    test(10000000000000.001 / 10000.0, 1000000000.0000001000);
    test(0.001, 0.0010000001);
    test(0.000000000000000000000101, 0.0);
    test(sqrt(2.0) * sqrt(2.0), 2.0);
    test(-sqrt(2.0) * sqrt(2.0), -2.0);
    test(3.14159265358979323846, 3.14159265358979324);
    return 0;
}
