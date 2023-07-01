import std.stdio, std.algorithm, std.range, std.typecons;

Nullable!(const ubyte[81]) solve(in ubyte[81] s) pure nothrow @safe @nogc {
    immutable i = s[].countUntil(0);
    if (i == -1)
        return typeof(return)(s);

    static immutable B = (in int i, in int j) pure nothrow @safe @nogc =>
        i / 27 ^ j / 27 | (i % 9 / 3 ^ j % 9 / 3);

    ubyte[81] c = void;
    size_t len = 0;
    foreach (immutable int j; 0 .. c.length)
        if (!((i - j) % 9 * (i/9 ^ j/9) * B(i, j)))
            c[len++] = s[j];

    foreach (immutable ubyte v; 1 .. 10)
        if (!c[0 .. len].canFind(v)) {
            ubyte[81] s2 = void;
            s2[0 .. i] = s[0 .. i];
            s2[i] = v;
            s2[i + 1 .. $] = s[i + 1 .. $];
            const r = solve(s2);
            if (!r.isNull)
                return typeof(return)(r);
        }
    return typeof(return)();
}

void main() {
    immutable ubyte[81] problem = [
        8, 5, 0, 0, 0, 2, 4, 0, 0,
        7, 2, 0, 0, 0, 0, 0, 0, 9,
        0, 0, 4, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 1, 0, 7, 0, 0, 2,
        3, 0, 5, 0, 0, 0, 9, 0, 0,
        0, 4, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 8, 0, 0, 7, 0,
        0, 1, 7, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 3, 6, 0, 4, 0];
    writefln("%(%s\n%)", problem.solve.get[].chunks(9));
}
