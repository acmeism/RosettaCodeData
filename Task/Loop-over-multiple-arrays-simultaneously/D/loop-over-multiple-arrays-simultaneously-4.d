import std.stdio, std.algorithm;

void main () {
    auto s1 = "abc";
    auto s2 = "ABC";
    auto a1 = [1, 2];

    foreach (i; 0 .. min(s1.length, s2.length, a1.length))
        writeln(s1[i], s2[i], a1[i]);
}
