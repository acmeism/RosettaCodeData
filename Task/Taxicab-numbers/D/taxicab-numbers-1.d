void main() /*@safe*/ {
    import std.stdio, std.range, std.algorithm, std.typecons, std.string;

    auto iCubes = iota(1u, 1201u).map!(x => tuple(x, x ^^ 3));
    bool[Tuple!(uint, uint)][uint] sum2cubes;
    foreach (i, immutable i3; iCubes)
        foreach (j, immutable j3; iCubes[i .. $])
            sum2cubes[i3 + j3][tuple(i, j)] = true;

    const taxis = sum2cubes.byKeyValue.filter!(p => p.value.length > 1)
                  .array.schwartzSort!(p => p.key).release;

    foreach (/*immutable*/ const r; [[0, 25], [2000 - 1, 2000 + 6]]) {
        foreach (immutable i, const t; taxis[r[0] .. r[1]])
            writefln("%4d: %10d =%-(%s =%)", i + r[0] + 1, t.key,
                     t.value.keys.sort().map!q{"%4d^3 + %4d^3".format(a[])});
        writeln;
    }
}
