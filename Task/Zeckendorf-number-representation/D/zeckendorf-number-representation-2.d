import std.stdio, std.typecons;

int zeckendorf(in int n) pure nothrow {
     Tuple!(int,"remaining", int,"set")
     zr(in int fib0, in int fib1, in int n, in uint bit) pure nothrow {
        if (fib1 > n)
            return typeof(return)(n, 0);
        auto rs = zr(fib1, fib0 + fib1, n, bit + 1);
        if (fib1 <= rs.remaining) {
            rs.set |= 1 << bit;
            rs.remaining -= fib1;
        }
        return rs;
    }

    return zr(1, 1, n, 0)[1];
}

void main() {
    foreach (i; 0 .. 21)
        writefln("%2d: %6b", i, zeckendorf(i));
}
