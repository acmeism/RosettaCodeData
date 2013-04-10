import std.stdio, std.random, std.conv, std.range, std.algorithm;

bool isBalanced(in char[] s) pure nothrow {
    static bool bal(in char[] s, in int nb=0) pure nothrow {
        if (nb == 0 && s.empty) return true;
        if (s.empty || nb < 0) return false;
        if (s[0] == '[') return bal(s[1 .. $], nb + 1);
        if (s[0] == ']') return bal(s[1 .. $], nb - 1);
        return bal(s[1 .. $], nb); // ignore char
    }
    return bal(s);
}

void main() {
    foreach (i; 1 .. 9) {
        auto sr = iota(i * 2).map!(_ => ['[',']'][uniform(0, 2)])();
        auto s = sr.array();
        writefln("%5s: %s", s.isBalanced().text(), s);
    }
}
