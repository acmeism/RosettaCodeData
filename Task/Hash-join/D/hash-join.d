import std.stdio, std.typecons;

auto hashJoin(size_t index1, size_t index2, T1, T2)
             (in T1[] table1, in T2[] table2) pure /*nothrow*/ @safe
if (is(typeof(T1.init[index1]) == typeof(T2.init[index2]))) {
    // Hash phase.
    T1[][typeof(T1.init[index1])] h;
    foreach (const s; table1)
        h[s[index1]] ~= s;

    // Join phase.
    Tuple!(const T1, const T2)[] result;
    foreach (const r; table2)
        foreach (const s; h.get(r[index2], null)) // Not nothrow.
            result ~= tuple(s, r);

    return result;
}

void main() {
    alias T = tuple;
    immutable table1 = [T(27, "Jonah"),
                        T(18, "Alan"),
                        T(28, "Glory"),
                        T(18, "Popeye"),
                        T(28, "Alan")];
    immutable table2 = [T("Jonah", "Whales"),
                        T("Jonah", "Spiders"),
                        T("Alan",  "Ghosts"),
                        T("Alan",  "Zombies"),
                        T("Glory", "Buffy")];

    foreach (const row; hashJoin!(1, 0)(table1, table2))
        writefln("(%s, %5s) (%5s, %7s)", row[0][], row[1][]);
}
