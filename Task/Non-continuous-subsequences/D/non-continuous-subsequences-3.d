import std.stdio, std.array, std.range, std.concurrency;

Generator!(T[]) ncsub(T)(in T[] seq) {
    return new typeof(return)({
        immutable n = seq.length;
        auto S = new T[n];

        foreach (immutable i; 1 .. 1 << n) {
            uint lenS = 0;
            bool nc = false;
            foreach (immutable j; 0 .. n + 1) {
                immutable k = i >> j;
                if (k == 0) {
                    if (nc)
                        yield(S[0 .. lenS]);
                    break;
                } else if (k % 2) {
                    S[lenS] = seq[j];
                    lenS++;
                } else if (lenS)
                    nc = true;
            }
        }
    });
}

void main() {
    assert(24.iota.array.ncsub.walkLength == 16_776_915);

    [1, 2, 3].ncsub.writeln;
    [1, 2, 3, 4].ncsub.writeln;
    foreach (const nc; [1, 2, 3, 4, 5].ncsub)
        nc.writeln;
}
