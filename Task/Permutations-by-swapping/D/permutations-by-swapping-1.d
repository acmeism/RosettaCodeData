import std.algorithm, std.array, std.typecons, std.range;

struct Spermutations(bool doCopy=true) {
    private immutable uint n;
    alias TResult = Tuple!(int[], int);

    int opApply(in int delegate(in ref TResult) dg) {
        int result;

        int sign = 1;
        alias Int2 = Tuple!(int, int);
        auto p = iota(n).map!(i => Int2(i, i ? -1 : 0))().array();
        TResult aux;

        if (doCopy) {
            aux[0] = p.map!(pp => pp[0])().array();
        } else {
            aux[0] = new int[n];
            foreach (immutable i, immutable pp; p)
                aux[0][i] = pp[0];
        }
        aux[1] = sign;
        result = dg(aux);
        if (result)
            goto END;

        while (p.canFind!(pp => pp[1])()) {
            // Failed to use std.algorithm here, too much complex.
            auto largest = Int2(-100, -100);
            int i1 = -1;
            foreach (immutable i, immutable pp; p) {
                if (pp[1]) {
                    if (pp[0] > largest[0]) {
                        i1 = i;
                        largest = pp;
                    }
                }
            }
            immutable n1 = largest[0], d1 = largest[1];

            sign *= -1;
            int i2;
            if (d1 == -1) {
                i2 = i1 - 1;
                swap(p[i1], p[i2]);
                if (i2 == 0 || p[i2 - 1][0] > n1)
                    p[i2][1] = 0;
            } else if (d1 == 1) {
                i2 = i1 + 1;
                swap(p[i1], p[i2]);
                if (i2 == n - 1 || p[i2 + 1][0] > n1)
                    p[i2][1] = 0;
            }

            if (doCopy) {
                aux[0] = p.map!(pp => pp[0])().array();
            } else {
                foreach (immutable i, immutable pp; p)
                    aux[0][i] = pp[0];
            }
            aux[1] = sign;
            result = dg(aux);
            if (result)
                goto END;

            foreach (immutable i3, ref pp; p) {
                immutable n3 = pp[0], d3 = pp[1];
                if (n3 > n1)
                    pp[1] = (i3 < i2) ? 1 : -1;
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
        foreach (n; [3, 4]) {
            writefln("\nPermutations and sign of %d items", n);
            foreach (tp; spermutations(n))
                writefln("Perm: %s  Sign: %2d", tp.tupleof);
        }
    }
}
