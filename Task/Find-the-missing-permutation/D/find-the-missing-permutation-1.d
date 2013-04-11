import std.stdio, std.string, std.algorithm, std.array, std.range;

void main() {
    const givenSet = "ABCD CABD ACDB DACB BCDA ACBD ADCB CDAB DABC
        BCAD CADB CDBA CBAD ABDC ADBC BDCA DCBA BACD BADC BDAC CBDA
        DBCA DCAB"d.split().zip(repeat(true)).assocArray();

    auto p = "ABCD"d.dup;
    do {
        if (p !in givenSet)
            writeln("Missing permutation: ", p);
    } while (p.nextPermutation());
}
