#include <stdio.h>
#include <math.h>

typedef struct {
    double x, y, z;
} vector;

vector add(vector v, vector w) {
    return (vector){v.x + w.x, v.y + w.y, v.z + w.z};
}

vector mul(vector v, double m) {
    return (vector){v.x * m, v.y * m, v.z * m};
}

vector div(vector v, double d) {
    return mul(v, 1.0 / d);
}

double vabs(vector v) {
    return sqrt(v.x * v.x + v.y * v.y + v.z * v.z);
}

vector mulAdd(vector v1, vector v2, double x1, double x2) {
    return add(mul(v1, x1), mul(v2, x2));
}

void vecAsStr(char buffer[], vector v) {
    sprintf(buffer, "(%.17g, %.17g, %.17g)", v.x, v.y, v.z);
}

void rotate(vector i, vector j, double alpha, vector ps[]) {
    ps[0] = mulAdd(i, j, cos(alpha), sin(alpha));
    ps[1] = mulAdd(i, j, -sin(alpha), cos(alpha));
}

void orbitalStateVectors(
    double semimajorAxis, double eccentricity, double inclination,
    double longitudeOfAscendingNode, double argumentOfPeriapsis,
    double trueAnomaly, vector ps[]) {

    vector i = {1.0, 0.0, 0.0};
    vector j = {0.0, 1.0, 0.0};
    vector k = {0.0, 0.0, 1.0};
    double l = 2.0, c, s, r, rprime;
    vector qs[2];
    rotate(i, j, longitudeOfAscendingNode, qs);
    i = qs[0]; j = qs[1];
    rotate(j, k, inclination, qs);
    j = qs[0];
    rotate(i, j, argumentOfPeriapsis, qs);
    i = qs[0]; j = qs[1];
    if (eccentricity != 1.0)  l = 1.0 - eccentricity * eccentricity;
    l *= semimajorAxis;
    c = cos(trueAnomaly);
    s = sin(trueAnomaly);
    r = l / (1.0 + eccentricity * c);
    rprime = s * r * r / l;
    ps[0] = mulAdd(i, j, c, s);
    ps[0] = mul(ps[0], r);
    ps[1] = mulAdd(i, j, rprime * c - r * s, rprime * s + r * c);
    ps[1] = div(ps[1], vabs(ps[1]));
    ps[1] = mul(ps[1], sqrt(2.0 / r - 1.0 / semimajorAxis));
}

int main() {
    double longitude = 355.0 / (113.0 * 6.0);
    vector ps[2];
    char buffer[80];
    orbitalStateVectors(1.0, 0.1, 0.0, longitude, 0.0, 0.0, ps);
    vecAsStr(buffer, ps[0]);
    printf("Position : %s\n", buffer);
    vecAsStr(buffer, ps[1]);
    printf("Speed    : %s\n", buffer);
    return 0;
}
