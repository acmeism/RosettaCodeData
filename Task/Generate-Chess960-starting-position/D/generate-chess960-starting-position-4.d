void main() {
    import std.stdio, std.regex, std.range, std.algorithm, permutations2;

    immutable pieces = "KQRRBBNN";
    immutable bish = r"B(|..|....|......)B";
    immutable king = r"R.*K.*R";
    auto starts3 = permutations(pieces.dup)
                   .filter!(p => p.match(bish) && p.match(king))
                   .array.sort().uniq;
    writeln(starts3.walkLength, "\n", starts3.front);
}
