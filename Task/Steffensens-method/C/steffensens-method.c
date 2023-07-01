#include <stdio.h>
#include <math.h>

double aitken(double (*f)(double), double p0) {
    double p1 = f(p0);
    double p2 = f(p1);
    double p1m0 = p1 - p0;
    return p0 - p1m0 * p1m0 / (p2 - 2.0 * p1 + p0);
}

double steffensenAitken(double (*f)(double), double pinit, double tol, int maxiter) {
    double p0 = pinit;
    double p = aitken(f, p0);
    int iter = 1;
    while (fabs(p - p0) > tol && iter < maxiter) {
        p0 = p;
        p = aitken(f, p0);
        ++iter;
    }
    if (fabs(p - p0) > tol) return nan("");
    return p;
}

double deCasteljau(double c0, double c1, double c2, double t) {
    double s = 1.0 - t;
    double c01 = s * c0 + t * c1;
    double c12 = s * c1 + t * c2;
    return s * c01 + t * c12;
}

double xConvexLeftParabola(double t) {
    return deCasteljau(2.0, -8.0, 2.0, t);
}

double yConvexRightParabola(double t) {
    return deCasteljau(1.0, 2.0, 3.0, t);
}

double implicitEquation(double x, double y) {
    return 5.0 * x * x + y - 5.0;
}

double f(double t) {
    double x = xConvexLeftParabola(t);
    double y = yConvexRightParabola(t);
    return implicitEquation(x, y) + t;
}

int main() {
    double t0 = 0.0, t, x, y;
    int i;
    for (i = 0; i < 11; ++i) {
        printf("t0 = %0.1f : ", t0);
        t = steffensenAitken(f, t0, 0.00000001, 1000);
        if (isnan(t)) {
            printf("no answer\n");
        } else {
            x = xConvexLeftParabola(t);
            y = yConvexRightParabola(t);
            if (fabs(implicitEquation(x, y)) <= 0.000001) {
                printf("intersection at (%f, %f)\n", x, y);
            } else {
                printf("spurious solution\n");
            }
        }
        t0 += 0.1;
    }
    return 0;
}
