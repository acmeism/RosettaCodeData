import std.math;
import std.stdio;

long mod(long x, long y) {
    long m = x % y;
    if (m < 0) {
        if (y < 0) {
            return m - y;
        } else {
            return m + y;
        }
    }
    return m;
}

class RNG {
private:
    // First generator
    immutable(long []) a1 = [0, 1403580, -810728];
    immutable long m1 = (1L << 32) - 209;
    long[3] x1;
    // Second generator
    immutable(long []) a2 = [527612, 0, -1370589];
    immutable long m2 = (1L << 32) - 22853;
    long[3] x2;
    // other
    immutable long d = m1 + 1;

public:
    void seed(long state) {
        x1 = [state, 0, 0];
        x2 = [state, 0, 0];
    }

    long next_int() {
        long x1i = mod((a1[0] * x1[0] + a1[1] * x1[1] + a1[2] * x1[2]), m1);
        long x2i = mod((a2[0] * x2[0] + a2[1] * x2[1] + a2[2] * x2[2]), m2);
        long z = mod(x1i - x2i, m1);

        // keep the last three values of the first generator
        x1 = [x1i, x1[0], x1[1]];
        // keep the last three values of the second generator
        x2 = [x2i, x2[0], x2[1]];

        return z + 1;
    }

    double next_float() {
        return cast(double) next_int() / d;
    }
}

void main() {
    auto rng = new RNG();

    rng.seed(1234567);
    writeln(rng.next_int);
    writeln(rng.next_int);
    writeln(rng.next_int);
    writeln(rng.next_int);
    writeln(rng.next_int);
    writeln;

    int[5] counts;
    rng.seed(987654321);
    foreach (i; 0 .. 100_000) {
        auto value = cast(int) floor(rng.next_float * 5.0);
        counts[value]++;
    }
    foreach (i,v; counts) {
        writeln(i, ": ", v);
    }
}
