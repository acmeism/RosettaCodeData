void main() {
    import std.stdio, std.math, std.algorithm, permutations2;

    ["Baker", "Cooper", "Fletcher", "Miller", "Smith"]
    .permutations
    .filter!(s =>
        s.countUntil("Baker") != 4 && s.countUntil("Cooper") &&
        s.countUntil("Fletcher") && s.countUntil("Fletcher") != 4 &&
        s.countUntil("Miller") > s.countUntil("Cooper") &&
        abs(s.countUntil("Smith") - s.countUntil("Fletcher")) != 1 &&
        abs(s.countUntil("Cooper") - s.countUntil("Fletcher")) != 1)
    .writeln;
}
