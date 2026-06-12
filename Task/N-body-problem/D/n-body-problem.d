import std.algorithm;
import std.array;
import std.conv;
import std.file;
import std.math : sqrt;
import std.stdio;
import std.string;

/// End of (type) recursion
void unpack(T)(T t) { /* empty */ }

/// Useful for unpacking tuples. Beware of assigning mutable buffers, for the u's will alias the original t's.
void unpack(T, U ...)(T t, ref U u) in {
    assert(t.length == u.length);
} body {
    if (t.length > 0) {
        u[0] = t[0];
        unpack(t[1..$], u[1..$]);
    }
}

unittest {
    auto t = ["one", "two"];
    string f, s;
    unpack(t, f, s);
    assert(f=="one");
    assert(s=="two");
}

alias FLOAT = real;

struct Vector3D {
    FLOAT x, y, z;

    this(FLOAT x, FLOAT y, FLOAT z) {
        this.x = x;
        this.y = y;
        this.z = z;
    }

    auto opBinary(string op : "+")(Vector3D v) {
        return Vector3D(x + v.x, y + v.y, z + v.z);
    }
    auto opOpAssign(string op : "+")(Vector3D v) {
        x += v.x;
        y += v.y;
        z += v.z;
        return this;
    }

    auto opBinary(string op : "-")(Vector3D v) {
        return Vector3D(x - v.x, y - v.y, z - v.z);
    }

    auto opBinary(string op : "*")(FLOAT s) {
        return Vector3D(s*x, s*y, s*z);
    }

    auto mod() {
        return sqrt(x*x + y*y + z*z);
    }
}

auto origin = Vector3D(0, 0, 0);

struct NBody {

    FLOAT gc;
    int bodies;
    int timeSteps;
    FLOAT[] masses;
    Vector3D[] positions;
    Vector3D[] velocities;
    Vector3D[] accelerations;

    this(string fileName) {
        auto lines = File(fileName).byLine();
        char[] g, b, t;
        lines.front.split().unpack(g, b, t);
        gc = g.to!FLOAT;
        bodies = b.to!int;
        timeSteps = t.to!int;
        lines.popFront; // Must come after g, b and t have been processed.

        masses.length = bodies;
        positions.length = bodies;
        positions[] = origin;
        velocities.length = bodies;
        velocities[] = origin;
        accelerations.length = bodies;
        accelerations[] = origin;
        foreach (i; 0..bodies) {
            masses[i] = lines.front.to!FLOAT;
            lines.popFront;
            positions[i] = decompose(lines.front);
            lines.popFront;
            velocities[i] = decompose(lines.front);
            lines.popFront;
        }
        writeln("Contents of $fileName");
        writeln(readText(fileName));
        writeln("Body   :      x          y          z    |");
        writeln("     vx         vy         vz");
    }

    private Vector3D decompose(char[] line) {
        FLOAT x, y, z;
        line.split().map!(to!FLOAT).unpack(x, y, z);
        return Vector3D(x, y, z);
    }

    private void computeAccelerations() {
        foreach (i; 0..bodies) {
            accelerations[i] = origin;
            foreach (j; 0..bodies) {
                if (i != j) {
                    auto temp = gc * masses[j] / (positions[i] - positions[j]).mod^^3;
                    accelerations[i] += (positions[j] - positions[i]) * temp;
                }
            }
        }
    }

    private void computePositions() {
        foreach (i; 0..bodies) {
            positions[i] += velocities[i] + accelerations[i] * 0.5;
        }
    }

    private void computeVelocities() {
        foreach(i; 0..bodies) velocities[i] += accelerations[i];
    }

    private void resolveCollisions() {
        foreach(i; 0..bodies) {
            foreach (j; i+1..bodies) {
                if (positions[i].x == positions[j].x &&
                    positions[i].y == positions[j].y &&
                    positions[i].z == positions[j].z) {
                    swap(velocities[i], velocities[j]);
                }
            }
        }
    }

    void simulate() {
        computeAccelerations();
        computePositions();
        computeVelocities();
        resolveCollisions();
    }

    void printResults() {
        auto fmt = "Body %d : % 8.6f  % 8.6f  % 8.6f | % 8.6f  % 8.6f  % 8.6f";
        foreach(i; 0..bodies) {
            writefln(fmt,
                i + 1,
                positions[i].x,
                positions[i].y,
                positions[i].z,
                velocities[i].x,
                velocities[i].y,
                velocities[i].z
            );
        }
    }
}

void main() {
    auto fileName = "nbody.txt";
    auto nb = NBody(fileName);
    foreach (i; 1..nb.timeSteps+1) {
        writeln("\nCycle ", i);
        nb.simulate();
        nb.printResults();
    }
}
