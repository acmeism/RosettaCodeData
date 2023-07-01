import std.stdio, std.bigint, std.range, std.algorithm, std.conv;

BigInt leftFact(in uint n) pure nothrow /*@safe*/ {
    BigInt result = 0, factorial = 1;
    foreach (immutable i; 1 .. n + 1) {
        result += factorial;
        factorial *= i;
    }
    return result;
}

void main() {
    writeln("First 11 left factorials:\n", 11.iota.map!leftFact);
    writefln("\n20 through 110 (inclusive) by tens:\n%(%s\n%)",
             iota(20, 111, 10).map!leftFact);
    writefln("\nDigits in 1,000 through 10,000 by thousands:\n%s",
             iota(1_000, 10_001, 1_000).map!(i => i.leftFact.text.length));
}
