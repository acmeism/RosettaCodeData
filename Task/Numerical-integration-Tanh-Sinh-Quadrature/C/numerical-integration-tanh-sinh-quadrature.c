#include <stdio.h>
#include <math.h>

#define PI 3.14159265358979323846

double tanh_sinh(double (*fp)(double), double lower, double upper, int steps, double acc) {
    double h = 0.1;
    double h0 = (upper - lower) / 2.0;
    double h1 = (lower + upper) / 2.0;
    double rr = 0.0;
    for (int k = 1; k <= steps; ++k) {
        double ro = rr;
        int n = (1 << k) - 1;
        double ss = 0.0;
        for (int i = -n; i <= n; ++i) {
            double t = i * h;
            double sh = sinh(t);
            double ch = cosh(t);
            double th = tanh(sh * PI / 2.0);
            double dx = (ch * PI / 2.0) / pow(cosh(sh * PI / 2.0), 2.0);
            double xi = h1 +  h0 * th;
            double wt = h * dx;
            ss += fp(xi) * wt;
        }
        rr = h0 * ss;
        if (fabs(rr - ro) < acc) break;
    }
    return rr;
}

int main() {
    double res = tanh_sinh(sin, 0.0, 1.0, 5, 1e-8);
    printf("%0.8f\n", res);
    res = tanh_sinh(exp, -3.0, 3.0, 5, 1e-8);
    printf("%0.8f\n", res);
    return 0;
}
