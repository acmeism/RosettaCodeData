import std.stdio, std.string, std.range, std.algorithm;

string nth(in uint n) pure {
    static immutable suffix = "th st nd rd th th th th th th".split;
    return "%d'%s".format(n, (n % 100 <= 10 || n % 100 > 20) ?
                             suffix[n % 10] : "th");
}

void main() {
    foreach (r; [iota(26), iota(250, 266), iota(1000, 1026)])
        writefln("%-(%s %)", r.map!nth);
}
