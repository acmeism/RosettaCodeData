import std.algorithm, std.range, std.string;

enum luhnTest = (in string n) pure /*nothrow*/ @safe /*@nogc*/ =>
    retro(n)
    .zip(only(1, 2).cycle)
    .map!(p => (p[0] - '0') * p[1])
    .map!(d => d / 10 + d % 10)
    .sum % 10 == 0;

void main() {
    assert("49927398716 49927398717 1234567812345678 1234567812345670"
           .split.map!luhnTest.equal([true, false, false, true]));
}
