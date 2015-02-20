void main() {
    import std.stdio, std.algorithm, std.range, std.random, combinations3;

    enum nDraw = 9, nGoal = nDraw / 2;
    auto deck = cartesianProduct("red green purple".split,
                                 "one two three".split,
                                 "oval squiggle diamond".split,
                                 "solid open striped".split).array;

    retry:
    auto draw = deck.randomSample(nDraw).map!(t => [t[]]).array;
    const sets = draw.combinations(3).filter!(cs => cs.dup
        .transposed.all!(t => t.array.sort().uniq.count % 2)).array;
    if (sets.length != nGoal)
        goto retry;

    writefln("Dealt %d cards:\n%(%-(%8s %)\n%)\n", draw.length, draw);
    writefln("Containing:\n%(%(%-(%8s %)\n%)\n\n%)", sets);
}
