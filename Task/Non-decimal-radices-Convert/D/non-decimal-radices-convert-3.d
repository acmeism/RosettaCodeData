import std.stdio, std.algorithm, std.ascii, std.array;

alias Digits = ubyte[];

Digits toBase(ulong number, in ubyte base) pure nothrow {
    Digits result;
    while (number) {
        result = number % base ~ result;
        number /= base;
    }
    return result;
}

enum fromBase = (in Digits digits, in ubyte base) pure nothrow =>
    reduce!((n, k) => n * base + k)(0UL, digits);

immutable myDigits = digits ~ lowercase;

enum fromDigits = (in Digits digits) pure nothrow =>
    digits.map!(d => myDigits[d]).array;

enum convert = (in dchar d) pure nothrow =>
    cast(ubyte)(d.isDigit ? d - '0' : d.toLower - 'a' + 10);

enum toDigits = (in string number) pure /*nothrow*/ =>
    number.map!convert.array;

void main() {
    "1ABcd".toDigits.fromBase(16).writeln;
}
