import std.stdio, std.traits, std.math, std.variant;

/// Returns a string with the error, or the three digits.
Algebraic!(string, char[3]) middleThreeDigits(T)(in T n)
if (isIntegral!T) {
    // Awkward code to face abs(T.min) when T is signed.
    ulong ln;
    static if (isSigned!T) {
        if (n >= 0) {
            ln = n;
        } else {
            if (n == T.min) {
                ln = -(n + 1);
                ln++;
            } else {
                ln = -n;
            }
        }
    } else {
        ln = n;
    }

    if (ln < 100)
        return typeof(return)("n is too short.");
    immutable uint digits = 1 + cast(uint)log10(ln);
    if (digits % 2 == 0)
        return typeof(return)("n must have an odd number of digits.");

    // From the Reddit answer by "millstone".
    int drop = (digits - 3) / 2;
    while (drop-- > 0)
        ln /= 10;

    char[3] result = void;
    result[2] = ln % 10 + '0';
    ln /= 10;
    result[1] = ln % 10 + '0';
    ln /= 10;
    result[0] = ln % 10 + '0';
    return typeof(return)(result);
}

void main() {
    immutable passing = [123, 12345, 1234567, 987654321, 10001,
                         -10001, -123, -100, 100, -12345, -8765432];
    foreach (n; passing) {
        auto mtd = middleThreeDigits(n);
        // A string result means it didn't pass.
        assert(!mtd.peek!string);
        writefln("middleThreeDigits(%d): %s", n, mtd);
    }
    writeln();

    immutable failing = [1, 2, -1, -10, 2002, -2002, 0,
                         15, int.min, int.max];
    foreach (n; failing) {
        auto mtd = middleThreeDigits(n);
        assert(mtd.peek!string);
        writefln("middleThreeDigits(%d): %s", n, mtd);
    }
    writeln();

    immutable long[] passingL = [123, 12345, 1234567, 987654321, 10001,
                                 -10001, -123, -100, 100, -12345,
                                 -8765432, long.min, long.max];
    foreach (n; passingL) {
        auto mtd = middleThreeDigits(n);
        assert(!mtd.peek!string);
        writefln("middleThreeDigits(%d): %s", n, mtd);
    }
    writeln();

    immutable long[] failingL = [1, 2, -1, -10, 2002, -2002, 0, 15];
    foreach (n; failingL) {
        auto mtd = middleThreeDigits(n);
        assert(mtd.peek!string);
        writefln("middleThreeDigits(%d): %s", n, mtd);
    }
    writeln();

    {
        immutable n = short.min;
        auto mtd = middleThreeDigits(n);
        assert(!mtd.peek!string);
        writefln("middleThreeDigits(cast(short)%d): %s", n, mtd);
    }
}
