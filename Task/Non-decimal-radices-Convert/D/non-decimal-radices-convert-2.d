import std.stdio, std.array, std.ascii;

enum string mDigits = "0123456789abcdefghijklmnopqrstuvwxyz";

ulong atoiRadix(in string str, in int radix=10, int* consumed=null) {
    static int dtoi(in char dc, in int radix) {
        static int[immutable char] digit;
        immutable char d = cast(char)toLower(dc);
        if (digit.length == 0) // not init yet
            foreach (i, c; mDigits)
                digit[c] = i;
        if (radix > 1 && radix <= digit.length &&
            d in digit && digit[d] < radix)
            return digit[d];
        return int.min; // a negative for error.
    }

    ulong result;
    int sp;
    for (; sp < str.length; sp++) {
        immutable int d = dtoi(str[sp], radix);
        if (d >= 0) // valid digit char
            result = radix * result + d;
        else
            break;
    }
    if (sp != str.length) // some char in str not converted.
        sp = -sp;
    if (consumed !is null) // signal error if not positive.
        *consumed = sp;
    return result;
}

string itoaRadix(ulong num, in int radix=10) pure nothrow
in {
    assert(radix > 1 && radix <= mDigits.length);
} body {
    string result;
    while (num > 0) {
        //immutable int d = num % radix;
        immutable int d = cast(int)(num % radix);
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
