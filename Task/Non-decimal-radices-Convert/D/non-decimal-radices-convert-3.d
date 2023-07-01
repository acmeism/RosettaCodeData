import std.stdio, std.algorithm, std.ascii, std.array, std.string;

alias Digits = ubyte[];

Digits toBase(ulong number, in ubyte base) pure nothrow @safe {
    Digits result;
    while (number) {
        result = number % base ~ result;
        number /= base;
    }
    return result;
}

enum fromBase = (in Digits digits, in ubyte base) pure nothrow @safe @nogc =>
    reduce!((n, k) => n * base + k)(0UL, digits);

immutable myDigits = digits ~ lowercase;

enum fromDigits = (in Digits digits) pure nothrow /*@safe*/ =>
    digits.map!(d => myDigits[d]).array;

enum convert = (in dchar d) pure nothrow @safe @nogc =>
    cast(ubyte)(d.isDigit ? d - '0' : std.ascii.toLower(d) - 'a' + 10);

enum toDigits = (in string number) pure nothrow @safe =>
    number.representation.map!convert.array;

void main() {
    "1ABcd".toDigits.fromBase(16).writeln;
}
