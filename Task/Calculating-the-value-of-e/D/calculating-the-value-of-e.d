import std.math;
import std.stdio;

enum EPSILON = 1.0e-15;

void main() {
    ulong fact = 1;
    double e = 2.0;
    double e0;
    int n = 2;
    do {
        e0 = e;
        fact *= n++;
        e += 1.0 / fact;
    } while (abs(e - e0) >= EPSILON);
    writefln("e = %.15f", e);
}
