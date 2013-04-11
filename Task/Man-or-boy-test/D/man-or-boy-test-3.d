import std.stdio;

int delegate() mb(T)(T mob) { // embeding function
    int b() {
        static if (is(T == int))
            return mob;
        else
            return mob();
    }

    return &b;
}

int A(T)(int k, T x1, T x2, T x3, T x4, T x5) {
    static if (is(T == int)) {
        return A(k, mb(x1), mb(x2), mb(x3), mb(x4), mb(x5));
    } else {
        int b() {
            k--;
            return A(k, &b, x1, x2, x3, x4);
        }
        return (k <= 0) ? x4() + x5() : b();
    }
}

void main() {
    writeln(A(10, 1, -1, -1, 1, 0));
}
