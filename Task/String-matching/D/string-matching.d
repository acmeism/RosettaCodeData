void main() {
    import std.stdio;
    import std.algorithm: startsWith, endsWith, find, countUntil;

    "abcd".startsWith("ab").writeln;      // true
    "abcd".endsWith("zn").writeln;        // false
    "abab".find("bb").writeln;            // empty array (no match)
    "abcd".find("bc").writeln;            // "bcd" (substring start
                                           //        at match)
    "abab".countUntil("bb").writeln;      // -1 (no match)
    "abab".countUntil("ba").writeln;      //  1 (index of 1st match)

    // std.algorithm.startsWith also works on arrays and ranges:
    [1, 2, 3].countUntil(3).writeln;      //  2
    [1, 2, 3].countUntil([2, 3]).writeln; //  1
}
