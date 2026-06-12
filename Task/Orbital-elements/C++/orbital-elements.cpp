#include <iostream>
#include <tuple>

class Vector {
private:
    double _x, _y, _z;

public:
    Vector(double x, double y, double z) : _x(x), _y(y), _z(z) {
        // empty
    }

    double getX() {
        return _x;
    }

    double getY() {
        return _y;
    }

    double getZ() {
        return _z;
    }

    double abs() {
        return sqrt(_x * _x + _y * _y + _z * _z);
    }

    Vector operator+(const Vector& rhs) const {
        return Vector(_x + rhs._x, _y + rhs._y, _z + rhs._z);
    }

    Vector operator*(double m) const {
        return Vector(_x * m, _y * m, _z * m);
    }

    Vector operator/(double m) const {
        return Vector(_x / m, _y / m, _z / m);
    }

    friend std::ostream& operator<<(std::ostream& os, const Vector& v);
};

std::ostream& operator<<(std::ostream& os, const Vector& v) {
    return os << '(' << v._x << ", " << v._y << ", " << v._z << ')';
}

std::pair<Vector, Vector> orbitalStateVectors(
    double semiMajorAxis,
    double eccentricity,
    double inclination,
    double longitudeOfAscendingNode,
    double argumentOfPeriapsis,
    double trueAnomaly
) {
    auto mulAdd = [](const Vector& v1, double x1, const Vector& v2, double x2) {
        return v1 * x1 + v2 * x2;
    };

    auto rotate = [mulAdd](const Vector& iv, const Vector& jv, double alpha) {
        return std::make_pair(
            mulAdd(iv, +cos(alpha), jv, sin(alpha)),
            mulAdd(iv, -sin(alpha), jv, cos(alpha))
        );
    };

    Vector i(1, 0, 0);
    Vector j(0, 1, 0);
    Vector k(0, 0, 1);

    auto p = rotate(i, j, longitudeOfAscendingNode);
    i = p.first; j = p.second;
    p = rotate(j, k, inclination);
    j = p.first;
    p = rotate(i, j, argumentOfPeriapsis);
    i = p.first; j = p.second;

    auto l = semiMajorAxis * ((eccentricity == 1.0) ? 2.0 : (1.0 - eccentricity * eccentricity));
    auto c = cos(trueAnomaly);
    auto s = sin(trueAnomaly);
    auto r = l / (1.0 + eccentricity * c);;
    auto rprime = s * r * r / l;
    auto position = mulAdd(i, c, j, s) * r;
    auto speed = mulAdd(i, rprime * c - r * s, j, rprime * s + r * c);
    speed = speed / speed.abs();
    speed = speed * sqrt(2.0 / r - 1.0 / semiMajorAxis);

    return std::make_pair(position, speed);
}

int main() {
    auto res = orbitalStateVectors(1.0, 0.1, 0.0, 355.0 / (113.0 * 6.0), 0.0, 0.0);
    std::cout << "Position : " << res.first << '\n';
    std::cout << "Speed    : " << res.second << '\n';

    return 0;
}
