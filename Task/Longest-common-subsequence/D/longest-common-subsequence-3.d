import std.stdio, std.algorithm, std.range, std.array, std.string, std.typecons;

uint[] lensLCS(R)(R xs, R ys) pure nothrow @safe {
    auto prev = new typeof(return)(1 + ys.length);
    auto curr = new typeof(return)(1 + ys.length);

    foreach (immutable x; xs) {
        swap(curr, prev);
        size_t i = 0;
        foreach (immutable y; ys) {
            curr[i + 1] = (x == y) ? prev[i] + 1 : max(curr[i], prev[i + 1]);
            i++;
        }
    }

    return curr;
}

void calculateLCS(T)(in T[] xs, in T[] ys, bool[] xs_in_lcs,
                     in size_t idx=0) pure nothrow @safe {
    immutable nx = xs.length;
    immutable ny = ys.length;

    if (nx == 0)
        return;

    if (nx == 1) {
        if (ys.canFind(xs[0]))
            xs_in_lcs[idx] = true;
    } else {
        immutable mid = nx / 2;
        const xb = xs[0.. mid];
        const xe = xs[mid .. $];
        immutable ll_b = lensLCS(xb, ys);

        const ll_e = lensLCS(xe.retro, ys.retro); // retro is slow with dmd.

        //immutable k = iota(ny + 1)
        //              .reduce!(max!(j => ll_b[j] + ll_e[ny - j]));
        immutable k = iota(ny + 1)
                      .minPos!((i, j) => tuple(ll_b[i] + ll_e[ny - i]) >
                                         tuple(ll_b[j] + ll_e[ny - j]))[0];

        calculateLCS(xb, ys[0 .. k], xs_in_lcs, idx);
        calculateLCS(xe, ys[k .. $], xs_in_lcs, idx + mid);
    }
}

const(T)[] lcs(T)(in T[] xs, in T[] ys) pure /*nothrow*/ @safe {
    auto xs_in_lcs = new bool[xs.length];
    calculateLCS(xs, ys, xs_in_lcs);
    return zip(xs, xs_in_lcs).filter!q{ a[1] }.map!q{ a[0] }.array; // Not nothrow.
}

string lcsString(in string s1, in string s2) pure /*nothrow*/ @safe {
    return lcs(s1.representation, s2.representation).assumeUTF;
}

void main() {
    lcsString("thisisatest", "testing123testing").writeln;
}
