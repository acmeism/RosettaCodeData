import core.stdc.stdio, std.range, std.array, std.algorithm, combinations3;

immutable uint[2][6] combs = 4u.iota.array.combinations(2).array;

void main() nothrow @nogc {
    immutable uint[3] scoring = [0, 1, 3];
    uint[10][4] histo;

    foreach (immutable r0; 0 .. 3)
     foreach (immutable r1; 0 .. 3)
      foreach (immutable r2; 0 .. 3)
       foreach (immutable r3; 0 .. 3)
        foreach (immutable r4; 0 .. 3)
         foreach (immutable r5; 0 .. 3) {
            uint[4] s;
            foreach (immutable i, immutable r; [r0, r1, r2, r3, r4, r5]) {
                s[combs[i][0]] += scoring[r];
                s[combs[i][1]] += scoring[2 - r];
            }

            foreach (immutable i, immutable v; s[].sort().release)
                histo[i][v]++;
         }

    foreach_reverse (const ref h; histo) {
        foreach (immutable x; h)
            printf("%u ", x);
        printf("\n");
    }
}
