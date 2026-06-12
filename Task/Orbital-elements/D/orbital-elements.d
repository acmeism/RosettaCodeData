import std.math;
import std.stdio;
import std.typecons;

struct Vector {
    double x, y, z;

    auto opBinary(string op : "+")(Vector rhs) {
        return Vector(x+rhs.x, y+rhs.y, z+rhs.z);
    }

    auto opBinary(string op : "*")(double m) {
        return Vector(x*m, y*m, z*m);
    }
    auto opOpAssign(string op : "*")(double m) {
        this.x *= m;
        this.y *= m;
        this.z *= m;
        return this;
    }

    auto opBinary(string op : "/")(double d) {
        return Vector(x/d, y/d, z/d);
    }
    auto opOpAssign(string op : "/")(double m) {
        this.x /= m;
        this.y /= m;
        this.z /= m;
        return this;
    }

    auto abs() {
        return sqrt(x * x + y * y + z * z);
    }

    void toString(scope void delegate(const(char)[]) sink) const {
        import std.format;
        sink("(");
        formattedWrite(sink, "%.16f", x);
        sink(", ");
        formattedWrite(sink, "%.16f", y);
        sink(", ");
        formattedWrite(sink, "%.16f", z);
        sink(")");
    }
}

auto orbitalStateVectors(
    double semiMajorAxis,
    double eccentricity,
    double inclination,
    double longitudeOfAscendingNode,
    double argumentOfPeriapsis,
    double trueAnomaly
) {
    auto i = Vector(1.0, 0.0, 0.0);
    auto j = Vector(0.0, 1.0, 0.0);
    auto k = Vector(0.0, 0.0, 1.0);

    auto mulAdd = (Vector v1, double x1, Vector v2, double x2) => v1 * x1 + v2 * x2;

    auto rotate = (Vector i, Vector j, double alpha) =>
        tuple(mulAdd(i, +cos(alpha), j, sin(alpha)),
              mulAdd(i, -sin(alpha), j, cos(alpha)));

    auto p = rotate(i, j, longitudeOfAscendingNode);
    i = p[0]; j = p[1];
    p = rotate(j, k, inclination);
    j = p[0];
    p = rotate(i, j, argumentOfPeriapsis);
    i = p[0]; j = p[1];

    auto l = semiMajorAxis * ((eccentricity == 1.0) ? 2.0 : (1.0 - eccentricity * eccentricity));
    auto c = cos(trueAnomaly);
    auto s = sin(trueAnomaly);
    auto r = l / (1.0 + eccentricity * c);
    auto rprime = s * r * r / l;
    auto position = mulAdd(i, c, j, s) * r;
    auto speed = mulAdd(i, rprime * c - r * s, j, rprime * s + r * c);
    speed /= speed.abs();
    speed *= sqrt(2.0 / r - 1.0 / semiMajorAxis);
    return tuple(position, speed);
}

void main() {
    auto res = orbitalStateVectors(1.0, 0.1, 0.0, 355.0 / (113.0 * 6.0), 0.0, 0.0);
    writeln("Position : ", res[0]);
    writeln("Speed    : ", res[1]);
}
