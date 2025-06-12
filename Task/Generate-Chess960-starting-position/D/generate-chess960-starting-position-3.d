void main() {
    import std.stdio, std.range, std.algorithm, std.string, permutations2;

    const pieces = "KQRrBbNN";
    alias I = indexOf;
    auto starts = pieces.dup.permutations.filter!(p =>
            I(p, 'B') % 2 != I(p, 'b') % 2 && // Bishop constraint.
            // King constraint.
            ((I(p, 'r') < I(p, 'K') && I(p, 'K') < I(p, 'R')) ||
             (I(p, 'R') < I(p, 'K') && I(p, 'K') < I(p, 'r'))))
        .map!toUpper.array.sort().uniq;
    writeln(starts.walkLength, "\n", starts.front);
}
