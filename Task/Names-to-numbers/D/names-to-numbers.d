import std.stdio, std.array, std.string, std.algorithm, std.bigint,
       std.range, number_names;

BigInt bigIntFromWords(in string num)
in {
    assert(!num.empty);
} body {
    auto words = num.replace(",", "").replace(" and ", " ")
                 .replace("-", " ").split;

    immutable sign = (words[0] == "minus") ? -1 : +1;
    if (sign == -1)
        words = words[1 .. $];

    BigInt bsmall, total;
    foreach (const word; words) {
        if (small.canFind(word)) {
            bsmall += small.countUntil(word);
        } else if (tens.canFind(word)) {
            bsmall += tens.countUntil(word) * 10;
        } else if (word == "hundred") {
            bsmall *= 100;
        } else if (word == "thousand") {
            total += bsmall * 1000;
            bsmall = 0;
        } else if (huge.canFind(word)) {
            total += bsmall * BigInt(1000) ^^ huge.countUntil(word);
            bsmall = 0;
        } else {
            immutable msg = format("Don't understand %s part of %s",
                                   word, num);
            throw new Exception(msg);
        }
    }

    return sign * (total + bsmall);
}

void main() {
    foreach (immutable n; iota(-10000, 10000, 17))
        assert(n == n.BigInt.spellBigInt.bigIntFromWords);

    foreach (immutable p; 0 .. 20) {
        auto n = 13.BigInt ^^ p;
        assert(n == n.spellBigInt.bigIntFromWords);
    }

    writeln("This shows <==> for a successful round trip, " ~
            " <??> otherwise:");
    foreach (immutable n; [0, -3, 5, -7, 11, -13, 17, -19, 23, -29]) {
        const txt = n.BigInt.spellBigInt;
        auto num = txt.bigIntFromWords;
        writefln("%+4d <%s> %s", n, (n == num) ? "==" : "??", txt);
    }
    writeln;

    long n = 201_021_002_001;
    while (n) {
        const txt = n.BigInt.spellBigInt;
        auto num = txt.bigIntFromWords;
        writefln("%12d <%s> %s", n, (n == num) ? "==" : "??", txt);
        n /= -10;
    }
    const txt = n.BigInt.spellBigInt;
    auto num = txt.bigIntFromWords;
    writefln("%12d <%s> %s", n, (n == num) ? "==" : "??", txt);
}
