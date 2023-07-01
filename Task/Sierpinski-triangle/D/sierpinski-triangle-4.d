import core.stdc.stdio: putchar;
import std.algorithm: swap;


void showSierpinskiTriangle(in uint nLevels) nothrow @safe
in {
    assert(nLevels > 0);
} body {
    alias Row = bool[];

    static void applyRules(in Row r1, Row r2) pure nothrow @safe @nogc {
        r2[0] = r1[0] || r1[1];
        r2[$ - 1] = r1[$ - 2] || r1[$ - 1];
        foreach (immutable i; 1 .. r2.length - 1)
            r2[i] = r1[i - 1] != r1[i] || r1[i] != r1[i + 1];
    }

    static void showRow(in Row r) nothrow @safe @nogc {
        foreach (immutable b; r)
            putchar(b ? '#' : ' ');
        '\n'.putchar;
    }

    immutable width = 2 ^^ (nLevels + 1) - 1;
    auto row1 = new Row(width);
    auto row2 = new Row(width);
    row1[width / 2] = true;

    foreach (immutable _; 0 .. 2 ^^ nLevels) {
        showRow(row1);
        applyRules(row1, row2);
        row1.swap(row2);
    }
}


void main() @safe nothrow {
    foreach (immutable i; 1 .. 6) {
        i.showSierpinskiTriangle;
        '\n'.putchar;
    }
}
