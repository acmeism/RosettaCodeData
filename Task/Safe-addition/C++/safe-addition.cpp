#include <iostream>
#include <tuple>

union conv {
    int i;
    float f;
};

float nextUp(float d) {
    if (isnan(d) || d == -INFINITY || d == INFINITY) return d;
    if (d == 0.0) return FLT_EPSILON;

    conv c;
    c.f = d;
    c.i++;

    return c.f;
}

float nextDown(float d) {
    if (isnan(d) || d == -INFINITY || d == INFINITY) return d;
    if (d == 0.0) return -FLT_EPSILON;

    conv c;
    c.f = d;
    c.i--;

    return c.f;
}

auto safeAdd(float a, float b) {
    return std::make_tuple(nextDown(a + b), nextUp(a + b));
}

int main() {
    float a = 1.20f;
    float b = 0.03f;

    auto result = safeAdd(a, b);
    printf("(%f + %f) is in the range (%0.16f, %0.16f)\n", a, b, std::get<0>(result), std::get<1>(result));

    return 0;
}
