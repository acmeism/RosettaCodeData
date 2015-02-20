import std.stdio;

T[] forwardDifference(T)(T[] s, in int n) pure nothrow @nogc {
    foreach (immutable i; 0 .. n)
        s[0 .. $ - i - 1] = s[1 .. $ - i] - s[0 .. $ - i - 1];
    return s[0 .. $ - n];
}
void main() {
    immutable A = [90.5, 47, 58, 29, 22, 32, 55, 5, 55, 73.5];
    foreach (immutable level; 0 .. A.length)
        forwardDifference(A.dup, level).writeln;
}
