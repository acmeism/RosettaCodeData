import std.stdio, std.array, std.string, std.range, std.algorithm;

immutable N = [0,1,1,1,1,1,1,1,1,1,1,1,1,1,1];
immutable G = [[0,1,3],[0,2,5],[1,3,6],[1,4,8],[2,4,7],[2,5,9],
    [3,4,5],[3,6,10],[3,7,12],[4,7,11],[4,8,13],[5,8,12],
    [5,9,14],[6,7,8],[7,8,9],[10,11,12],[11,12,13],[12,13,14]];

string b2s(in int[] n) pure @safe {
    static immutable fmt = 6.iota
                           .map!(i => " ".replicate(5 - i) ~ "%d ".replicate(i))
                           .join('\n');
    return fmt.format(n[0], n[1], n[2],  n[3],  n[4],  n[5],  n[6],
                      n[7], n[8], n[9], n[10], n[11], n[12], n[13], n[14]);
}

string solve(in int[] n, in int i, in int[] g) pure @safe {
    if (i == N.length - 1)
        return "\nSolved";
    if (n[g[1]] == 0)
        return null;
    string s;
    if (n[g[0]] == 0) {
        if (n[g[2]] == 0)
            return null;
        s = "\n%d to %d\n".format(g[2], g[0]);
    } else {
        if (n[g[2]] == 1)
            return null;
        s = "\n%d to %d\n".format(g[0], g[2]);
    }

    auto a = n.dup;
    foreach (const gi; g)
        a[gi] = 1 - a[gi];
    string l;
    foreach (const gi; G) {
        l = solve(a, i + 1, gi);
        if (!l.empty)
            break;
    }
    return l.empty ? l : (s ~ b2s(a) ~ l);
}

void main() @safe {
    b2s(N).write;
    string l;
    foreach (const g; G) {
        l = solve(N, 1, g);
        if (!l.empty)
            break;
    }
    writeln(l.empty ? "No solution found." : l);
}
