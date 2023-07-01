import std.bigint;
import std.math;
import std.stdio;

void fun(ref BigInt a, ref BigInt b, int c) {
    auto t = a;
    a = b;
    b = b * c + t;
}

void solvePell(int n, ref BigInt a, ref BigInt b) {
    int x = cast(int) sqrt(cast(real) n);
    int y = x;
    int z = 1;
    int r = x << 1;
    BigInt e1 = 1;
    BigInt e2 = 0;
    BigInt f1 = 0;
    BigInt f2 = 1;
    while (true) {
        y = r * z - y;
        z = (n - y * y) / z;
        r = (x + y) / z;
        fun(e1, e2, r);
        fun(f1, f2, r);
        a = f2;
        b = e2;
        fun(b, a, x);
        if (a * a - n * b * b == 1) {
            return;
        }
    }
}

void main() {
    BigInt x, y;
    foreach(n; [61, 109, 181, 277]) {
        solvePell(n, x, y);
        writefln("x^2 - %3d * y^2 = 1 for x = %27d and y = %25d", n, x, y);
    }
}
