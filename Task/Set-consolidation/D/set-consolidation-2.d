import std.stdio, std.algorithm, std.array;

dchar[][] consolidate(dchar[][] sets) {
    foreach (set; sets)
        set.sort;

    dchar[][] consolidateR(dchar[][] s) {
        if (s.length < 2)
            return s;
        auto r = [s[0]];
        foreach (x; consolidateR(s[1 .. $])) {
            if (!r[0].setIntersection(x).empty) {
                r[0] = r[0].setUnion(x).uniq.array;
            } else
                r ~= x;
        }
        return r;
    }

    return consolidateR(sets);
}

void main() {
    [['A', 'B'], ['C','D']].consolidate.writeln;

    [['A','B'], ['B','D']].consolidate.writeln;

    [['A','B'], ['C','D'], ['D','B']].consolidate.writeln;

    [['H','I','K'], ['A','B'], ['C','D'],
     ['D','B'], ['F','G','H']].consolidate.writeln;
}
