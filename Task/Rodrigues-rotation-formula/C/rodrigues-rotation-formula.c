#include <stdio.h>
#include <math.h>

typedef struct {
    double x, y, z;
} vector;

typedef struct {
    vector i, j, k;
} matrix;

double norm(vector v) {
    return sqrt(v.x*v.x + v.y*v.y + v.z*v.z);
}

vector normalize(vector v){
    double length = norm(v);
    vector n = {v.x / length, v.y / length, v.z / length};
    return n;
}

double dotProduct(vector v1, vector v2) {
    return v1.x*v2.x + v1.y*v2.y + v1.z*v2.z;
}

vector crossProduct(vector v1, vector v2) {
    vector cp = {v1.y*v2.z - v1.z*v2.y, v1.z*v2.x - v1.x*v2.z, v1.x*v2.y - v1.y*v2.x};
    return cp;
}

double getAngle(vector v1, vector v2) {
    return acos(dotProduct(v1, v2) / (norm(v1)*norm(v2)));
}

vector matrixMultiply(matrix m ,vector v) {
    vector mm = {dotProduct(m.i, v), dotProduct(m.j, v), dotProduct(m.k, v)};
    return mm;
}

vector aRotate(vector p, vector v, double a) {
    double ca = cos(a), sa = sin(a);
    double t = 1.0 - ca;
    double x = v.x, y = v.y, z = v.z;
    matrix r = {
        {ca + x*x*t, x*y*t - z*sa, x*z*t + y*sa},
        {x*y*t + z*sa, ca + y*y*t, y*z*t - x*sa},
        {z*x*t - y*sa, z*y*t + x*sa, ca + z*z*t}
    };
    return matrixMultiply(r, p);
}

int main() {
    vector v1 = {5, -6, 4}, v2 = {8, 5, -30};
    double a = getAngle(v1, v2);
    vector cp = crossProduct(v1, v2);
    vector ncp = normalize(cp);
    vector np = aRotate(v1, ncp, a);
    printf("[%.13f, %.13f, %.13f]\n", np.x, np.y, np.z);
    return 0;
}
