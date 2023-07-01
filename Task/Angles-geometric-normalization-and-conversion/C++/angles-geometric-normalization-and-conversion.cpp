#include <functional>
#include <iostream>
#include <iomanip>
#include <math.h>
#include <sstream>
#include <vector>
#include <boost/algorithm/string.hpp>

template<typename T>
T normalize(T a, double b) { return std::fmod(a, b); }

inline double d2d(double a) { return normalize<double>(a, 360); }
inline double g2g(double a) { return normalize<double>(a, 400); }
inline double m2m(double a) { return normalize<double>(a, 6400); }
inline double r2r(double a) { return normalize<double>(a, 2*M_PI); }

double d2g(double a) { return g2g(a * 10 / 9); }
double d2m(double a) { return m2m(a * 160 / 9); }
double d2r(double a) { return r2r(a * M_PI / 180); }
double g2d(double a) { return d2d(a * 9 / 10); }
double g2m(double a) { return m2m(a * 16); }
double g2r(double a) { return r2r(a * M_PI / 200); }
double m2d(double a) { return d2d(a * 9 / 160); }
double m2g(double a) { return g2g(a / 16); }
double m2r(double a) { return r2r(a * M_PI / 3200); }
double r2d(double a) { return d2d(a * 180 / M_PI); }
double r2g(double a) { return g2g(a * 200 / M_PI); }
double r2m(double a) { return m2m(a * 3200 / M_PI); }

void print(const std::vector<double> &values, const char *s, std::function<double(double)> f) {
    using namespace std;
    ostringstream out;
    out << "                  ┌───────────────────┐\n";
    out << "                  │ " << setw(17) << s << " │\n";
    out << "┌─────────────────┼───────────────────┤\n";
    for (double i : values)
        out << "│ " << setw(15) << fixed << i << defaultfloat << " │ " << setw(17) << fixed << f(i) << defaultfloat << " │\n";
    out << "└─────────────────┴───────────────────┘\n";
    auto str = out.str();
    boost::algorithm::replace_all(str, ".000000", "       ");
    cout << str;
}

int main() {
    std::vector<double> values = { -2, -1, 0, 1, 2, 6.2831853, 16, 57.2957795, 359, 399, 6399, 1000000 };
    print(values, "normalized (deg)", d2d);
    print(values, "normalized (grad)", g2g);
    print(values, "normalized (mil)", m2m);
    print(values, "normalized (rad)", r2r);

    print(values, "deg -> grad ", d2g);
    print(values, "deg -> mil ", d2m);
    print(values, "deg -> rad ", d2r);

    print(values, "grad -> deg ", g2d);
    print(values, "grad -> mil ", g2m);
    print(values, "grad -> rad ", g2r);

    print(values, "mil -> deg ", m2d);
    print(values, "mil -> grad ", m2g);
    print(values, "mil -> rad ", m2r);

    print(values, "rad -> deg ", r2d);
    print(values, "rad -> grad ", r2g);
    print(values, "rad -> mil ", r2m);

    return 0;
}
