import std.stdio, std.algorithm, std.range, std.array, std.conv;
// http://rosettacode.org/wiki/Combinations#D
import combinations4: Comb;

alias int[] iRNG;

iRNG setDiff(iRNG s, iRNG c) {
    return setDifference(s, c).array();
}

iRNG[][] orderPart(iRNG blockSize...) {
    iRNG sum = iota(1, 1 + blockSize.reduce!q{a + b}()).array();

    iRNG[][] p(iRNG s, in iRNG b) {
        if (b.length == 0)
            return [[]];
        iRNG[][] res;
        foreach (c; Comb.On(s, b[0]))
            foreach (r; p(setDiff(s, c), b[1 .. $]))
                res ~= c.dup ~ r;
        return res;
    }

    return p(sum, blockSize);
}

void main(string[] args) {
    auto b = args.length > 1 ?
        args[1 .. $].map!(to!int)().array() :
        [2, 0, 2];

    foreach (p; orderPart(b))
        writeln(p);
}
