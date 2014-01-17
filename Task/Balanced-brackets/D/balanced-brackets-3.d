import std.stdio, std.random, std.range, std.algorithm;

bool isBalanced(in string s, in string pars="[]") pure nothrow {
    bool bal(in string t, in int nb = 0) pure nothrow {
        if (!nb && t.empty) return true;
        if (t.empty || nb < 0) return false;
        if (t[0] == pars[0]) return bal(t.dropOne, nb + 1);
        if (t[0] == pars[1]) return bal(t.dropOne, nb - 1);
        return bal(t.dropOne, nb); // Ignore char.
    }
    return bal(s);
}

void main() {
    foreach (immutable i; 1 .. 9) {
        immutable s = iota(i * 2).map!(_ => "[]"[uniform(0, $)]).array;
        writeln(s.isBalanced ? " OK " : "Bad ", s);
    }
}
