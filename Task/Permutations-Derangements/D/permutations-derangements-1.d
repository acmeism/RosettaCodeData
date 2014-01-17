import std.stdio, std.algorithm, std.typecons, std.conv, std.range;

T factorial(T)(in T n) pure nothrow {
    Unqual!T result = 1;
    foreach (immutable i; 2 .. n + 1)
        result *= i;
    return result;
}

T subfact(T)(in T n) pure nothrow {
    if (0 <= n && n <= 2)
        return n != 1;
    return (n - 1) * (subfact(n - 1) + subfact(n - 2));
}

auto derangements(in size_t n, in bool countOnly=false)
pure /*nothrow*/ {
    size_t[] seq = n.iota.array;
    auto ori = seq.idup; // Not nothrow.
    size_t[][] all;
    size_t cnt = n == 0;

    foreach (immutable tot; 0 .. n.factorial - 1) {
        size_t j = n - 2;
        while (seq[j] > seq[j + 1])
            j--;
        size_t k = n - 1;
        while (seq[j] > seq[k])
            k--;
        seq[k].swap(seq[j]);

        size_t r = n - 1;
        size_t s = j + 1;
        while (r > s) {
            seq[s].swap(seq[r]);
            r--;
            s++;
        }

        j = 0;
        while (j < n && seq[j] != ori[j])
            j++;
        if (j == n) {
            if (countOnly)
                cnt++;
            else
                all ~= seq.dup; // Not nothrow.
        }
    }

    return tuple(all, cnt);
}

void main() {
    "Derangements for n = 4:".writeln;
    foreach (const d; 4.derangements[0])
        d.writeln;

    "\nTable of n vs counted vs calculated derangements:".writeln;
    foreach (immutable i; 0 .. 10)
        writefln("%s  %-7s%-7s", i, derangements(i, 1)[1], i.subfact);

    writefln("\n!20 = %s", 20L.subfact);
}
