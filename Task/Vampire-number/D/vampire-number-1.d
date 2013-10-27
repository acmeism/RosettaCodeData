import std.stdio, std.range, std.algorithm, std.typecons, std.conv;

auto fangs(in long n) {
    auto pairs = iota(2, cast(int)(n ^^ 0.5)) // n.isqrt
                 .filter!(x => !(n % x)).map!(x => [x, n / x]);
    enum dLen = (long x) => x.text.length;
    immutable half = dLen(n) / 2;
    enum halvesQ = (long[] p) => p.all!(u => dLen(u) == half);
    enum digits = (long[] p) => dtext(p[0], p[1]).dup.sort();
    const dn = n.to!(dchar[]).sort();
    return tuple(n, pairs.filter!(p => halvesQ(p) && dn == digits(p)));
}

void main() {
    foreach (v; int.max.iota.map!fangs.filter!q{ !a[1].empty }
                .take(25).chain([16758243290880, 24959017348650,
                                 14593825548650].map!fangs))
        writefln("%d: (%(%(%s %)) (%))", v[]);
}
