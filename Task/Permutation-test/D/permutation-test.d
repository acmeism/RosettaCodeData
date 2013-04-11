import std.stdio, std.algorithm, std.array;
// http://rosettacode.org/wiki/Combinations#D
import combinations3: combinations;

auto permTest(T)(T[] a, T[] b, in int precisionAdjust=100) {
    alias reduce!q{a + b} sum; // statistic can be degenerate to sum

    auto ab = a ~ b;
    ab[] *= precisionAdjust; // scale up magnitude
    auto tObs = sum(ab[0 .. a.length]);
    auto comb = combinations!false(ab, a.length);

    // combinations() isn't a Range yet
    //immutable int under = comb.count!(c => stat(c) <= tObs)();
    int under = 0;
    foreach (c; comb)
        if (sum(c) <= tObs)
            under++;

    return 1.0L * under / comb.length;
}

void main() {
    auto treatment = [0.85, 0.88, 0.75, 0.66, 0.25, 0.29,
                      0.83, 0.39, 0.97];
    auto control = [0.68, 0.41, 0.10, 0.49, 0.16, 0.65,
                    0.32, 0.92, 0.28, 0.98];

    auto r = permTest(treatment, control);
    writefln("under =%6.2f%%\nover  =%6.2f%%",
             r * 100.0, (1 - r) * 100.0);
}
