import std.stdio, std.algorithm, std.typecons, std.array,
       std.conv, std.range, std.traits;

auto derangements(in size_t n, in bool countOnly=false)
/*pure nothrow*/ {
    size_t[] seq = iota(n).array();
    auto ori = seq.idup;
    size_t[][] all;
    size_t cnt = n == 0;

    foreach (tot; 0 .. fact(n)-1) {
        size_t j = n - 2;
        while (seq[j] > seq[j + 1])
            j--;
        size_t k = n - 1;
        while (seq[j] > seq[k])
            k--;
        swap(seq[k], seq[j]);

        size_t r = n - 1;
        size_t s = j + 1;
        while (r > s) {
            swap(seq[s], seq[r]);
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
                all ~= seq.dup;
        }
    }

    return tuple(all, cnt);
}

T fact(T)(in T n) pure nothrow {
    Unqual!T result = 1;
    for (Unqual!T i = 2; i <= n; i++)
        result *= i;
    return result;
}

T subfact(T)(in T n) pure nothrow {
    if (0 <= n && n <= 2)
        return n != 1;
    return (n - 1) * (subfact(n - 1) + subfact(n - 2));
}

void main() {
    writeln("derangements for n = 4\n");
    foreach (d; derangements(4)[0])
        writeln(d);

    writeln("\ntable of n vs counted vs calculated derangements\n");
    foreach (i; 0 .. 10)
        writefln("%s  %-7s%-7s", i, derangements(i, 1)[1], subfact(i));

    writefln("\n!20 = %s", subfact(20L));
}
