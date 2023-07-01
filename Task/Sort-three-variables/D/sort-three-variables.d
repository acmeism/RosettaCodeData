import std.stdio;

void main() {
    driver(77444, -12, 0);
    driver("lions, tigers, and", "bears, oh my!", "(from the \"Wizard of OZ\")");
}

void driver(T)(T x, T y, T z) {
    writeln("BEFORE: x=[", x, "]; y=[", y, "]; z=[", z, "]");
    sort3Var(x,y,z);
    writeln("AFTER: x=[", x, "]; y=[", y, "]; z=[", z, "]");
}

void sort3Var(T)(ref T x, ref T y, ref T z)
out {
    assert(x<=y);
    assert(x<=z);
    assert(y<=z);
}
body {
    import std.algorithm : swap;

    if (x < y) {
        if (z < x) {
            swap(x,z);
        }
    } else if (y < z) {
        swap(x,y);
    } else {
        swap(x,z);
    }
    if (z<y) {
        swap(y,z);
    }
}
