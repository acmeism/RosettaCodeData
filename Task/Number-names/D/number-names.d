import std.stdio, std.string;

string spellInteger(in long n) pure nothrow {
    static immutable tens = ["", "", "twenty", "thirty", "forty",
        "fifty", "sixty", "seventy", "eighty", "ninety"];

    static immutable small = "zero one two three four five six
        seven eight nine ten eleven twelve thirteen fourteen
        fifteen sixteen seventeen eighteen nineteen".split();

    static immutable bl = ["", "", "m", "b", "tr",
        "quadr", "quint", "sext", "sept", "oct", "non", "dec"];

    static string nonZero(in string c, in int n) pure nothrow {
        return n == 0 ? "" : c ~ spellInteger(n);
    }

    static string big(in int e, in int n) pure nothrow {
        switch (e) {
            case 0: return spellInteger(n);
            case 1: return spellInteger(n) ~ " thousand";
            default: return spellInteger(n) ~ " " ~ bl[e] ~ "illion";
        }
    }

    /// Generates the value of the digits of n in
    /// base 1000 (i.e. 3-digit chunks), in reverse.
    static int[] base1000Reverse(in long nn) pure nothrow {
        long n = nn;
        int[] result;
        while (n) {
            result ~= n % 1000;
            n /= 1000;
        }
        return result;
    }

    if (n < 0) {
        return "negative " ~ spellInteger(-n);
    } else if (n < 1000) {
        int ni = cast(int)n; // D doesn't infer this.
        if (ni < 20) {
            return small[ni];
        } else if (ni < 100) {
            return tens[ni / 10] ~ nonZero("-", ni % 10);
        } else // ni < 1000
            return small[ni / 100] ~ " hundred" ~
                   nonZero(" ", ni % 100);
    } else {
        string[] pieces;
        foreach_reverse (e, x; base1000Reverse(n))
            pieces ~= big(e, x);
        return pieces.join(", ");
    }
}

void main() {
    foreach (i; -10 .. 1_000)
        writeln(i, " ", spellInteger(i));
}
