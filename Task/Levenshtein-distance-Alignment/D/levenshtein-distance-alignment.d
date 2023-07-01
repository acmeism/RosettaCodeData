void main() {
    import std.stdio, std.algorithm;

    immutable s1 = "rosettacode";
    immutable s2 = "raisethysword";

    string s1b, s2b;
    size_t pos1, pos2;

    foreach (immutable c; levenshteinDistanceAndPath(s1, s2)[1]) {
        final switch (c) with (EditOp) {
            case none, substitute:
                s1b ~= s1[pos1++];
                s2b ~= s2[pos2++];
                break;
            case insert:
                s1b ~= "_";
                s2b ~= s2[pos2++];
                break;
            case remove:
                s1b ~= s1[pos1++];
                s2b ~= "_";
                break;
        }
    }

    writeln(s1b, "\n", s2b);
}
