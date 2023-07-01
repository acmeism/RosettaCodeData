#include <math.h>
#include <stdbool.h>
#include <stdio.h>

bool approxEquals(double value, double other, double epsilon) {
    return fabs(value - other) < epsilon;
}

void test(double a, double b) {
    double epsilon = 1e-18;
    printf("%f, %f => %d\n", a, b, approxEquals(a, b, epsilon));
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
