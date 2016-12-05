#pragma once

#include <cmath>
#include <string>
#include <sstream>
#include <iomanip>

class Approx {
public:
    Approx(double _v, double _s = 0.0) : v(_v), s(_s) {}

    operator std::string() const {
        std::ostringstream os("");
        os << std::setprecision(15) << v << " ±" << std::setprecision(15) << s << std::ends;
        return os.str();
    }

    Approx operator +(const Approx& a) const { return Approx(v + a.v, sqrt(s * s + a.s * a.s)); }
    Approx operator +(double d) const { return Approx(v + d, s); }
    Approx operator -(const Approx& a) const { return Approx(v - a.v, sqrt(s * s + a.s * a.s)); }
    Approx operator -(double d) const { return Approx(v - d, s); }

    Approx operator *(const Approx& a) const {
        const double t = v * a.v;
        return Approx(v, sqrt(t * t * s * s / (v * v) + a.s * a.s / (a.v * a.v)));
    }

    Approx operator *(double d) const { return Approx(v * d, fabs(d * s)); }

    Approx operator /(const Approx& a) const {
        const double t = v / a.v;
        return Approx(t, sqrt(t * t * s * s / (v * v) + a.s * a.s / (a.v * a.v)));
    }

    Approx operator /(double d) const { return Approx(v / d, fabs(d * s)); }

    Approx pow(double d) const {
        const double t = ::pow(v, d);
        return Approx(t, fabs(t * d * s / v));
    }

private:
    double v, s;
};
