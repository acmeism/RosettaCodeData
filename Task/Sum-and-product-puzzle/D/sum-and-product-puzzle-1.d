void main() {
    import std.stdio, std.algorithm, std.range, std.typecons;

    const s1 = cartesianProduct(iota(1, 101), iota(1, 101))
               .filter!(p => 1 < p[0] && p[0] < p[1] && p[0] + p[1] < 100)
               .array;

    alias P = const Tuple!(int, int);
    enum add   = (P p) => p[0] + p[1];
    enum mul   = (P p) => p[0] * p[1];
    enum sumEq = (P p) => s1.filter!(q => add(q) == add(p));
    enum mulEq = (P p) => s1.filter!(q => mul(q) == mul(p));

    const s2 = s1.filter!(p => sumEq(p).all!(q => mulEq(q).walkLength != 1)).array;
    const s3 = s2.filter!(p => mulEq(p).setIntersection(s2).walkLength == 1).array;
    s3.filter!(p => sumEq(p).setIntersection(s3).walkLength == 1).writeln;
}
