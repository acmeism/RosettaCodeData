import std.stdio, std.numeric;

long myGCD(in long x, in long y) pure nothrow @nogc {
    if (y == 0)
        return x;
    return myGCD(y, x % y);
}

void main() {
    gcd(15, 10).writeln; // From Phobos.
    myGCD(15, 10).writeln;
}
