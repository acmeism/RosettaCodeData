#include <iomanip>
#include <iostream>
#include <vector>

#define _USE_MATH_DEFINES
#include <math.h>

template<typename C>
double meanAngle(const C& c) {
    auto it = std::cbegin(c);
    auto end = std::cend(c);

    double x = 0.0;
    double y = 0.0;
    double len = 0.0;
    while (it != end) {
        x += cos(*it * M_PI / 180);
        y += sin(*it * M_PI / 180);
        len++;

        it = std::next(it);
    }

    return atan2(y, x) * 180 / M_PI;
}

void printMean(std::initializer_list<double> init) {
    std::cout << std::fixed << std::setprecision(3) << meanAngle(init) << '\n';
}

int main() {
    printMean({ 350, 10 });
    printMean({ 90, 180, 270, 360 });
    printMean({ 10, 20, 30 });

    return 0;
}
