import std.conv;
import std.stdio;

ulong uabs(ulong a, ulong b) {
    if (a > b) {
        return a - b;
    }
    return b - a;
}

bool isEsthetic(ulong n, ulong b) {
    if (n == 0) {
        return false;
    }
    auto i = n % b;
    n /= b;
    while (n > 0) {
        auto j = n % b;
        if (uabs(i, j) != 1) {
            return false;
        }
        n /= b;
        i = j;
    }
    return true;
}

ulong[] esths;

void dfs(ulong n, ulong m, ulong i) {
    if (i >= n && i <= m) {
        esths ~= i;
    }
    if (i == 0 || i > m) {
        return;
    }
    auto d = i % 10;
    auto i1 = i * 10 + d - 1;
    auto i2 = i1 + 2;
    if (d == 0) {
        dfs(n, m, i2);
    } else if (d == 9) {
        dfs(n, m, i1);
    } else {
        dfs(n, m, i1);
        dfs(n, m, i2);
    }
}

void listEsths(ulong n, ulong n2, ulong m, long m2, int perLine, bool all) {
    esths.length = 0;
    for (auto i = 0; i < 10; i++) {
        dfs(n2, m2, i);
    }
    auto le = esths.length;
    writefln("Base 10: %s esthetic numbers between %s and %s:", le, n, m);
    if (all) {
        foreach (c, esth; esths) {
            write(esth, ' ');
            if ((c + 1) % perLine == 0) {
                writeln;
            }
        }
        writeln;
    } else {
        for (auto i = 0; i < perLine; i++) {
            write(esths[i], ' ');
        }
        writeln("\n............");
        for (auto i = le - perLine; i < le; i++) {
            write(esths[i], ' ');
        }
        writeln;
    }
    writeln;
}

void main() {
    for (auto b = 2; b <= 16; b++) {
        writefln("Base %d: %dth to %dth esthetic numbers:", b, 4 * b, 6 * b);
        for (auto n = 1, c = 0; c < 6 * b; n++) {
            if (isEsthetic(n, b)) {
                c++;
                if (c >= 4 * b) {
                    write(to!string(n, b), ' ');
                }
            }
        }
        writeln;
    }
    writeln;

    // the following all use the obvious range limitations for the numbers in question
    listEsths(1000, 1010, 9999, 9898, 16, true);
    listEsths(cast(ulong) 1e8, 101_010_101, 13*cast(ulong) 1e7, 123_456_789, 9, true);
    listEsths(cast(ulong) 1e11, 101_010_101_010, 13*cast(ulong) 1e10, 123_456_789_898, 7, false);
    listEsths(cast(ulong) 1e14, 101_010_101_010_101, 13*cast(ulong) 1e13, 123_456_789_898_989, 5, false);
    listEsths(cast(ulong) 1e17, 101_010_101_010_101_010, 13*cast(ulong) 1e16, 123_456_789_898_989_898, 4, false);
}
