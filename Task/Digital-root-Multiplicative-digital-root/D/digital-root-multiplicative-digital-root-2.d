import std.stdio, std.algorithm, std.typecons, std.range;

uint digitsProduct(uint n) pure nothrow @nogc {
    typeof(return) result = !!n;
    while (n) {
        result *= n % 10;
        n /= 10;
    }
    return result;
}

/// Multiplicative digital root.
Tuple!(size_t, uint) mdRoot(uint m) pure nothrow {
    auto mdr = m
               .recurrence!((a, n) => a[n - 1].digitsProduct)
               .until!q{ a <= 9 }(OpenRight.no).array;
    return tuple(mdr.length - 1, mdr.back);
}

void main() {
    "Number: (MP, MDR)\n======  =========".writeln;
    foreach (immutable n; [123321, 7739, 893, 899998])
        writefln("%6d: (%s, %s)", n, n.mdRoot[]);

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
