import std.stdio, std.algorithm, std.random;

void main() {
    foreach (i; 1 .. 9) {
        string s;
        foreach (_; 0 .. i * 2)
            s ~= "[]"[uniform(0, 2)];
        writeln(s.balancedParens('[', ']') ? " OK: " : "bad: ", s);
    }
}
