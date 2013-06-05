import std.stdio, std.random, std.conv, std.range, std.algorithm;

bool isBalanced(in string s) pure nothrow {
    static bool bal(in string s, in int nb = 0) pure nothrow {
        if (nb == 0 && s.empty) return true;
        if (s.empty || nb < 0) return false;
        if (s[0] == '[') return bal(s[1 .. $], nb + 1);
        if (s[0] == ']') return bal(s[1 .. $], nb - 1);
        return bal(s[1 .. $], nb); // Ignore char.
    }
    return bal(s);
}

void main() {
    foreach (immutable i; 1 .. 9) {
        immutable s = iota(i * 2).map!(_ => "[]"[uniform(0, 2)]).array;
        writeln(s.isBalanced ? " OK " : "Bad ", s);
    }
}
