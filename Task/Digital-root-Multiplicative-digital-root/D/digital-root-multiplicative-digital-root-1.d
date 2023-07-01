import std.stdio, std.algorithm, std.typecons, std.range, std.conv;

/// Multiplicative digital root.
auto mdRoot(in int n) pure /*nothrow*/ {
    auto mdr = [n];
    while (mdr.back > 9)
        mdr ~= reduce!q{a * b}(1, mdr.back.text.map!(d => d - '0'));
        //mdr ~= mdr.back.text.map!(d => d - '0').mul;
        //mdr ~= mdr.back.reverseDigits.mul;
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
