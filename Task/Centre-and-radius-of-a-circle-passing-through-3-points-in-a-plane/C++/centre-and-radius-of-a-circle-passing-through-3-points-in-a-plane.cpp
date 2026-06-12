#include <iostream>
#include <math.h>
using namespace std;

void findCircle(float x1, float y1, float x2, float y2, float x3, float y3) {
    float x12 = x1 - x2;
    float x13 = x1 - x3;
    float y12 = y1 - y2;
    float y13 = y1 - y3;
    float y31 = y3 - y1;
    float y21 = y2 - y1;
    float x31 = x3 - x1;
    float x21 = x2 - x1;

    float sx13 = pow(x1, 2) - pow(x3, 2);
    float sy13 = pow(y1, 2) - pow(y3, 2);
    float sx21 = pow(x2, 2) - pow(x1, 2);
    float sy21 = pow(y2, 2) - pow(y1, 2);

    float f = ((sx13) * (x12) + (sy13) * (x12) + (sx21) * (x13) + (sy21) * (x13))
            / (2 * ((y31) * (x12) - (y21) * (x13)));
    float g = ((sx13) * (y12) + (sy13) * (y12) + (sx21) * (y13) + (sy21) * (y13))
            / (2 * ((x31) * (y12) - (x21) * (y13)));

    float c = -pow(x1, 2) - pow(y1, 2) - 2 * g * x1 - 2 * f * y1;
    float h = -g;
    float k = -f;
    float r = sqrt(h * h + k * k - c);

    cout << "Centre is at (" << h << ", " << k << ")" << endl;
    cout << "Radius is " << r;
}

int main() {
    findCircle(22.83, 2.07, 14.39, 30.24, 33.65, 17.31);

    return 0;
}
