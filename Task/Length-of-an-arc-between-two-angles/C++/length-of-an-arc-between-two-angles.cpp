#include <iostream>

#define _USE_MATH_DEFINES
#include <math.h>

double arcLength(double radius, double angle1, double angle2) {
    return (360.0 - abs(angle2 - angle1)) * M_PI * radius / 180.0;
}

int main() {
    auto al = arcLength(10.0, 10.0, 120.0);
    std::cout << "arc length: " << al << '\n';
    return 0;
}
