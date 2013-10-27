import std.stdio, std.array, std.ascii;

immutable string mDigits = digits ~ lowercase;

ulong atoiRadix(in string str, in uint radix=10, int* consumed=null)
nothrow {
    static int dtoi(in char dc, in uint radix) nothrow {
        static int[immutable char] digit;
        immutable char d = dc.toLower;
        if (digit.length == 0) // Not init yet.
            foreach (i, c; mDigits)
                digit[c] = i;
        if (radix > 1 && radix <= digit.length &&
            d in digit && digit[d] < radix)
            return digit[d];
        return int.min; // A negative for error.
    }

    ulong result;
    int sp;
    for (; sp < str.length; sp++) {
        immutable int d = dtoi(str[sp], radix);
        if (d >= 0) // Valid digit char.
            result = radix * result + d;
        else
            break;
    }
    if (sp != str.length) // Some char in str not converted.
        sp = -sp;
    if (consumed !is null) // Signal error if not positive.
        *consumed = sp;
    return result;
}

string itoaRadix(ulong num, in uint radix=10) pure nothrow
in {
    assert(radix > 1 && radix <= mDigits.length);
} body {
    string result;
    while (num > 0) {
        immutable uint d = num % radix;
        result = mDigits[d] ~ result;
        num = (num - d) / radix;
    }
    return result.empty ? "0" : result;
}

void main() {
    immutable string numStr = "1ABcdxyz???";

    int ate;
    writef("'%s' (base %d) = %d", numStr, 16,
           atoiRadix(numStr, 16, &ate));

    if (ate <= 0)
        writefln("\tConverted only: '%s'", numStr[0 .. -ate]);
    else
        writeln();

    writeln(itoaRadix(60_272_032_366, 36), " ",
            itoaRadix(591_458, 36));
}
