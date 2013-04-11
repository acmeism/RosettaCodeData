import std.stdio;

T[] forwardDifference(T)(T[] s, in int n) pure {
    foreach (_; 0 .. n)
        s[] -= s[1 .. $];
    return s[0 .. $ - n];
}
void main() {
    immutable A = [90.5, 47, 58, 29, 22, 32, 55, 5, 55, 73.5];
    foreach (level; 0 .. A.length)
        writeln(forwardDifference(A.dup, level));
}
