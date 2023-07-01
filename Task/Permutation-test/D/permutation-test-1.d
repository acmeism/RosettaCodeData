import std.stdio, std.algorithm, std.array, combinations3;

auto permutationTest(T)(in T[] a, in T[] b) pure nothrow @safe {
    immutable tObs = a.sum;
    auto combs = combinations!false(a ~ b, a.length);
    immutable under = combs.count!(perm => perm.sum <= tObs);
    return under * 100.0 / combs.length;
}

void main() {
    immutable treatmentGroup = [85, 88, 75, 66, 25, 29, 83, 39, 97];
    immutable controlGroup = [68, 41, 10, 49, 16, 65, 32, 92, 28, 98];
    immutable under = permutationTest(treatmentGroup, controlGroup);
    writefln("Under =%6.2f%%\nOver  =%6.2f%%", under, 100.0 - under);
}
