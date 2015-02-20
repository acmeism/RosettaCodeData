import std.stdio, std.array, std.algorithm, std.bigint, std.range;

immutable tens = ["", "", "twenty", "thirty", "forty",
                  "fifty", "sixty", "seventy", "eighty", "ninety"];
immutable small = ["zero", "one", "two", "three", "four", "five",
                   "six", "seven", "eight", "nine", "ten", "eleven",
                   "twelve", "thirteen", "fourteen", "fifteen",
                   "sixteen", "seventeen", "eighteen", "nineteen"];
immutable huge = ["", ""] ~ ["m", "b", "tr", "quadr", "quint",
                             "sext", "sept", "oct", "non", "dec"]
                            .map!q{ a ~ "illion" }.array;

string spellBigInt(BigInt n) pure /*nothrow @safe*/ {
    static string nonZero(string c, BigInt n, string connect="") pure /*nothrow @safe*/ {
        return (n == 0) ? "" : (connect ~ c ~ n.spellBigInt);
    }

    static string lastAnd(string num) pure /*nothrow*/ @safe {
        if (num.canFind(',')) {
            string pre = num.retro.find(',').retro[0 .. $ - 1];
            string last = num[pre.length + 1 .. $];
            if (!last.canFind(" and "))
                last = " and" ~ last;
            num = pre ~ ',' ~ last;
        }
        return num;
    }

    static string big(in uint e, in BigInt n) pure /*nothrow @safe*/ {
        switch (e) {
            case 0:  return n.spellBigInt;
            case 1:  return n.spellBigInt ~ " thousand";
            default: return n.spellBigInt ~ " " ~ huge[e];
        }
    }

    if (n < 0) {
        return "minus " ~ spellBigInt(-n);
    } else if (n < 20) {
        return small[n.toInt];
    } else if (n < 100) {
        immutable BigInt a = n / 10;
        immutable BigInt b = n % 10;
        return tens[a.toInt] ~ nonZero("-", b);
    } else if (n < 1_000) {
        immutable BigInt a = n / 100;
        immutable BigInt b = n % 100;
        return small[a.toInt] ~ " hundred" ~ nonZero(" ", b, " and");
    } else {
        string[] bigs;
        uint e = 0;
        while (n != 0) {
            immutable BigInt r = n % 1_000;
            n /= 1_000;
            if (r != 0)
                bigs ~= big(e, r);
            e++;
        }

        return lastAnd(bigs.retro.join(", "));
    }
}

version(number_names_main) {
    void main() {
        foreach (immutable n; [0, -3, 5, -7, 11, -13, 17, -19, 23, -29])
            writefln("%+4d -> %s", n, n.BigInt.spellBigInt);
        writeln;

        auto n = 2_0121_002_001;
        while (n) {
            writefln("%-12d -> %s", n, n.BigInt.spellBigInt);
            n /= -10;
        }
        writefln("%-12d -> %s", n, n.BigInt.spellBigInt);
        writeln;
    }
}
