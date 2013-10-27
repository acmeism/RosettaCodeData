import std.algorithm, std.array, std.typecons, std.range;

struct Spermutations(bool doCopy=true) {
    private immutable uint n;
    alias TResult = Tuple!(int[], int);

    int opApply(in int delegate(in ref TResult) dg) {
        int result;

        int sign = 1;
        alias Int2 = Tuple!(int, int);
        auto p = n.iota.map!(i => Int2(i, i ? -1 : 0)).array;
        TResult aux;

        aux[0] = p.map!(pi => pi[0]).array;
        aux[1] = sign;
        result = dg(aux);
        if (result)
            goto END;

        while (p.canFind!q{ a[1] }) {
            // Failed to use std.algorithm here, too much complex.
            auto largest = Int2(-100, -100);
            int i1 = -1;
            foreach (immutable i, immutable pi; p) {
                if (pi[1]) {
                    if (pi[0] > largest[0]) {
                        i1 = i;
                        largest = pi;
                    }
                }
            }
            immutable n1 = largest[0],
                      d1 = largest[1];

            sign *= -1;
            int i2;
            if (d1 == -1) {
                i2 = i1 - 1;
                p[i1].swap(p[i2]);
                if (i2 == 0 || p[i2 - 1][0] > n1)
                    p[i2][1] = 0;
            } else if (d1 == 1) {
                i2 = i1 + 1;
                p[i1].swap(p[i2]);
                if (i2 == n - 1 || p[i2 + 1][0] > n1)
                    p[i2][1] = 0;
            }

            if (doCopy) {
                aux[0] = p.map!(pi => pi[0]).array;
            } else {
                foreach (immutable i, immutable pi; p)
                    aux[0][i] = pi[0];
            }
            aux[1] = sign;
            result = dg(aux);
            if (result)
                goto END;

            foreach (immutable i3, ref pi; p) {
                immutable n3 = pi[0],
                          d3 = pi[1];
                if (n3 > n1)
                    pi[1] = (i3 < i2) ? 1 : -1;
            }
        }

        END: return result;
    }
}

Spermutations!doCopy spermutations(bool doCopy=true)(in uint n) {
    return typeof(return)(n);
}

version (permutations_by_swapping1) {
    void main() {
        import std.stdio;
        foreach (immutable n; [3, 4]) {
            writefln("\nPermutations and sign of %d items", n);
            foreach (const tp; n.spermutations)
                writefln("Perm: %s  Sign: %2d", tp[]);
        }
    }
}
