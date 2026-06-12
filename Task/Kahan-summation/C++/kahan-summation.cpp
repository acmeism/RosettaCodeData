#include <iostream>

float epsilon() {
    float eps = 1.0f;
    while (1.0f + eps != 1.0f) eps /= 2.0f;
    return eps;
}

float kahanSum(std::initializer_list<float> nums) {
    float sum = 0.0f;
    float c = 0.0f;
    for (auto num : nums) {
        float y = num - c;
        float t = sum + y;
        c = (t - sum) - y;
        sum = t;
    }
    return sum;
}

int main() {
    using namespace std;

    float a = 1.f;
    float b = epsilon();
    float c = -b;

    cout << "Epsilon      = " << b << endl;
    cout << "(a + b) + c  = " << (a + b) + c << endl;
    cout << "Kahan sum    = " << kahanSum({ a, b, c }) << endl;

    return 0;
}
