import std.stdio, std.conv, std.algorithm, std.exception, std.ascii,
       std.array;

alias Digits = ubyte[];

Digits toBase(ulong number, in ubyte base) pure nothrow {
    Digits result;
    while (number) {
        result = number % base ~ result;
        number /= base;
    }
    return result;
}

ulong fromBase(in Digits digits, in ubyte base) pure nothrow {
    return reduce!((n, k) => n * base + k)(0, digits);
}

string fromDigits(in Digits digits) pure nothrow {
    return digits
           .map!(d => cast(char)(d < 10 ? d + '0' : d + 'a' - 10))
           .array;
}

Digits toDigits(in string number) pure /*nothrow*/ {
    static ubyte convert(in dchar d) pure nothrow {
        if (d.isDigit) return cast(typeof(return))(d - '0');
        if (d.isUpper) return cast(typeof(return))(d - 'A' + 10);
        else           return cast(typeof(return))(d - 'a' + 10);
    }
    return number.map!convert.array;
}

void main() {
    "1ABcd".toDigits.fromBase(16).writeln;
}
