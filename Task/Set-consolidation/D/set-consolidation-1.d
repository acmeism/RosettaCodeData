import std.stdio, std.algorithm, std.array;

dchar[][] consolidate(dchar[][] sets) {
    foreach (set; sets)
        set.sort;

    foreach (i, ref si; sets[0 .. $ - 1]) {
        if (si.empty)
            continue;
        foreach (ref sj; sets[i + 1 .. $])
            if (!sj.empty && !si.setIntersection(sj).empty) {
                sj = si.setUnion(sj).uniq.array;
                si = null;
            }
    }

    return sets.filter!"!a.empty".array;
}

void main() {
    [['A', 'B'], ['C','D']].consolidate.writeln;

    [['A','B'], ['B','D']].consolidate.writeln;

    [['A','B'], ['C','D'], ['D','B']].consolidate.writeln;

    [['H','I','K'], ['A','B'], ['C','D'],
     ['D','B'], ['F','G','H']].consolidate.writeln;
}
