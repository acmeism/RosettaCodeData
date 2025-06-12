#include <iostream>
#include <cmath>

double agm(double a, double g, double tolerance = 1e-16) {
    double an = a;
    double gn = g;

    an = (a + g) / 2.0;
    gn = std::sqrt(a*g);
    while (std::abs(an-gn) > tolerance) {
        an = (an + gn) / 2.0;
        gn = std::sqrt(an*gn);
    }

    return an;
}

int main() {
    std::cout << "Arithmetic-geometric mean of 1 and 1/√2 is " << agm(1, 1/std::sqrt(2)) << "\n";

    return 0;
}
