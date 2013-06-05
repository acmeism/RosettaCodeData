import std.stdio, std.algorithm, std.range, std.array, std.string;

int[] lensLCS(R)(R xs, R ys) /*pure nothrow*/ {
    auto prev = new int[1 + ys.length];
    auto curr = new int[1 + ys.length];

    foreach (immutable x; xs) {
        swap(curr, prev);
        size_t i = 0;
        foreach (immutable y; ys) {
            curr[i + 1] = (x == y)
                          ? prev[i] + 1
                          : max(curr[i], prev[i + 1]);
            i++;
        }
    }

    return curr;
}

void calculateLCS(T)(in T[] xs, in T[] ys, bool[] xs_in_lcs,
                     in size_t idx=0) /*pure nothrow*/ {
    immutable nx = xs.length;
    immutable ny = ys.length;

    if (nx == 0)
        return;

    if (nx == 1) {
        if (ys.canFind(xs[0]))
            xs_in_lcs[idx] = true;
    } else {
        immutable mid = nx / 2;
        auto xb = xs[0.. mid];
        auto xe = xs[mid .. $];

        auto ll_b = lensLCS(xb, ys);

        // retro is slow with dmd.
        auto ll_e = lensLCS(xe.retro, ys.retro);

        //immutable k = iota(ny + 1)
        //              .reduce!(max!(j => ll_b[j] + ll_e[ny - j]));

        // Disallows -inline.
        // immutable k = iota(ny + 1)
        //               .map!(j => tuple(ll_b[j] + ll_e[ny - j], j))
        //               .reduce!max[1];

        int maxSum = -1;
        size_t k = 0;
        foreach (immutable i; 0 .. ny + 1) {
            immutable sum = ll_b[i] + ll_e[ny - i];
            if (sum > maxSum) {
                maxSum = sum;
                k = i;
            }
        }

        auto yb = ys[0 .. k];
        auto ye = ys[k .. $];

        calculateLCS(xb, yb, xs_in_lcs, idx);
        calculateLCS(xe, ye, xs_in_lcs, idx + mid);
    }
}

const(T)[] lcs(T)(in T[] xs, in T[] ys) /*pure nothrow*/ {
    auto xs_in_lcs = new bool[xs.length];
    calculateLCS(xs, ys, xs_in_lcs);

    return zip(xs, xs_in_lcs)
           .filter!q{ a[1] }
           .map!q{ a[0] }
           .array;
}

string lcsString(in string s1, in string s2) {
    return cast(string)lcs(s1.representation, s2.representation);
}

void main() {
    lcsString("thisisatest", "testing123testing").writeln;
}
