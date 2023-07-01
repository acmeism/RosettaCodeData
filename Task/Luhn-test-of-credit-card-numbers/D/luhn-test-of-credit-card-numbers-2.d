import std.algorithm;

bool luhnTest(in string num) @safe pure nothrow @nogc {
    uint sum;
    foreach_reverse (immutable i, immutable n; num) {
        immutable uint ord = n - '\u0030';
        sum += ((num.length - i) & 1) ? ord : ord / 5 + (2 * ord) % 10;
    }
    return sum % 10 == 0;
}

void main() {
    immutable data = ["49927398716",
                      "49927398717",
                      "1234567812345678",
                      "1234567812345670"];
    assert(data.map!luhnTest.equal([true, false, false, true]));
}
