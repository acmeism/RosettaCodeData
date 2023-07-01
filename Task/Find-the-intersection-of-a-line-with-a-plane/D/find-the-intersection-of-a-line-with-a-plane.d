import std.stdio;

struct Vector3D {
    private real x;
    private real y;
    private real z;

    this(real x, real y, real z) {
        this.x = x;
        this.y = y;
        this.z = z;
    }

    auto opBinary(string op)(Vector3D rhs) const {
        static if (op == "+" || op == "-") {
            mixin("return Vector3D(x" ~ op ~ "rhs.x, y" ~ op ~ "rhs.y, z" ~ op ~ "rhs.z);");
        }
    }

    auto opBinary(string op : "*")(real s) const {
        return Vector3D(s*x, s*y, s*z);
    }

    auto dot(Vector3D rhs) const {
        return x*rhs.x + y*rhs.y + z*rhs.z;
    }

    void toString(scope void delegate(const(char)[]) sink) const {
        import std.format;

        sink("(");
        formattedWrite!"%f"(sink, x);
        sink(",");
        formattedWrite!"%f"(sink, y);
        sink(",");
        formattedWrite!"%f"(sink, z);
        sink(")");
    }
}

auto intersectPoint(Vector3D rayVector, Vector3D rayPoint, Vector3D planeNormal, Vector3D planePoint) {
    auto diff = rayPoint - planePoint;
    auto prod1 = diff.dot(planeNormal);
    auto prod2 = rayVector.dot(planeNormal);
    auto prod3 = prod1 / prod2;
    return rayPoint - rayVector * prod3;
}

void main() {
    auto rv = Vector3D(0.0, -1.0, -1.0);
    auto rp = Vector3D(0.0,  0.0, 10.0);
    auto pn = Vector3D(0.0,  0.0,  1.0);
    auto pp = Vector3D(0.0,  0.0,  5.0);
    auto ip = intersectPoint(rv, rp, pn, pp);
    writeln("The ray intersects the plane at ", ip);
}
