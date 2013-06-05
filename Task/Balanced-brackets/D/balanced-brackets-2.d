import std.stdio, std.random, std.range, std.algorithm;

bool isBalanced(in string txt) pure nothrow {
    auto count = 0;

    foreach (immutable c; txt) {
        if (c == ']') {
            count--;
            if (count < 0)
                return false;
        } else if (c == '[')
            count++;
    }

    return count == 0;
}

void main() {
    foreach (immutable i; 1 .. 9) {
        immutable s = iota(i * 2).map!(_ => "[]"[uniform(0, 2)]).array;
        writeln(s.isBalanced ? " OK " : "Bad ", s);
    }
}
