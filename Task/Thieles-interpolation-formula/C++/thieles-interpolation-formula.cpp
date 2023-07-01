#include <cmath>
#include <iostream>
#include <iomanip>
#include <string.h>

constexpr unsigned int N = 32u;
double xval[N], t_sin[N], t_cos[N], t_tan[N];

constexpr unsigned int N2 = N * (N - 1u) / 2u;
double r_sin[N2], r_cos[N2], r_tan[N2];

double ρ(double *x, double *y, double *r, int i, int n) {
    if (n < 0)
        return 0;
    if (!n)
        return y[i];

    unsigned int idx = (N - 1 - n) * (N - n) / 2 + i;
    if (r[idx] != r[idx])
        r[idx] = (x[i] - x[i + n]) / (ρ(x, y, r, i, n - 1) - ρ(x, y, r, i + 1, n - 1)) + ρ(x, y, r, i + 1, n - 2);
    return r[idx];
}

double thiele(double *x, double *y, double *r, double xin, unsigned int n) {
    return n > N - 1 ? 1. : ρ(x, y, r, 0, n) - ρ(x, y, r, 0, n - 2) + (xin - x[n]) / thiele(x, y, r, xin, n + 1);
}

inline auto i_sin(double x) { return thiele(t_sin, xval, r_sin, x, 0); }
inline auto i_cos(double x) { return thiele(t_cos, xval, r_cos, x, 0); }
inline auto i_tan(double x) { return thiele(t_tan, xval, r_tan, x, 0); }

int main() {
    constexpr double step = .05;
    for (auto i = 0u; i < N; i++) {
        xval[i] = i * step;
        t_sin[i] = sin(xval[i]);
        t_cos[i] = cos(xval[i]);
        t_tan[i] = t_sin[i] / t_cos[i];
    }
    for (auto i = 0u; i < N2; i++)
        r_sin[i] = r_cos[i] = r_tan[i] = NAN;

    std::cout << std::setw(16) << std::setprecision(25)
              << 6 * i_sin(.5) << std::endl
              << 3 * i_cos(.5) << std::endl
              << 4 * i_tan(1.) << std::endl;

    return 0;
}
