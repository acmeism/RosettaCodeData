import std.stdio;

int A(int k, int delegate()[] x ...) {
    int b() {
        k--;
        return A(k, &b, x[0], x[1], x[2], x[3]);
    }

    return (k <= 0) ? x[3]() + x[4]() : b();
}

void main() {
    writeln(A(10, 1, -1, -1, 1, 0));
}
