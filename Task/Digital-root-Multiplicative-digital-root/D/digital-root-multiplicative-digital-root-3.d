import std.stdio, std.algorithm, std.range;

/// Multiplicative digital root.
uint[2] mdRoot(in uint n) pure nothrow @nogc {
    uint mdr = n;
    uint count = 0;

    while (mdr > 9) {
        uint m = mdr;
        uint digitsMul = !!m;
        while (m) {
            digitsMul *= m % 10;
            m /= 10;
        }
        mdr = digitsMul;
        count++;
    }

    return [count, mdr];
}

void main() {
    "Number: [MP, MDR]\n======  =========".writeln;
    foreach (immutable n; [123321, 7739, 893, 899998])
        writefln("%6d: %s", n, n.mdRoot);

    auto table = (int[]).init.repeat.enumerate!int.take(10).assocArray;
    auto n = 0;
    while (table.byValue.map!walkLength.reduce!min < 5) {
        table[n.mdRoot[1]] ~= n;
        n++;
    }
    "\nMP: [n0..n4]\n==  ========".writeln;
    foreach (const mp; table.byKey.array.sort())
        writefln("%2d: %s", mp, table[mp].take(5));
}
