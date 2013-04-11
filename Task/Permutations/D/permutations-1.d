import std.stdio: writeln;

T[][] permutations(T)(T[] items) {
    T[][] result;

    void perms(T[] s, T[] prefix=[]) {
        if (s.length)
            foreach (i, c; s)
               perms(s[0 .. i] ~ s[i+1 .. $], prefix ~ c);
        else
            result ~= prefix;
    }

    perms(items);
    return result;
}

void main() {
    foreach (p; permutations([1, 2, 3]))
        writeln(p);
}
