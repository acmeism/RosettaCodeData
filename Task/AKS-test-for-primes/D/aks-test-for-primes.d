import std.stdio, std.range, std.algorithm, std.string, std.bigint;

BigInt[] expandX1(in uint p) pure /*nothrow*/ {
    if (p == 0) return [1.BigInt];
    typeof(return) r = [1.BigInt, BigInt(-1)];
    foreach (immutable _; 1 .. p)
        r = zip(r~0.BigInt, 0.BigInt~r).map!(xy => xy[0]-xy[1]).array;
    r.reverse();
    return r;
}

bool aksTest(in uint p) pure /*nothrow*/ {
    if (p < 2) return false;
    auto ex = p.expandX1;
    ex[0]++;
    return !ex[0 .. $ - 1].any!(mult => mult % p);
}

void main() {
    "# p: (x-1)^p for small p:".writeln;
    foreach (immutable p; 0 .. 12)
        writefln("%3d: %s", p, p.expandX1.zip(iota(p + 1)).retro
                 .map!q{"%+dx^%d ".format(a[])}.join.replace("x^0", "")
                 .replace("^1 ", " ").replace("+", "+ ")
                 .replace("-", "- ").replace(" 1x", " x")[2 .. $]);

    "\nSmall primes using the AKS test:".writeln;
    101.iota.filter!aksTest.writeln;
}
