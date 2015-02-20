import std.stdio, std.bigint;

enum uint nMax = 250;
enum uint nBranches = 4;

__gshared BigInt[nMax + 1] rooted = [1.BigInt, 1.BigInt /*...*/],
                           unrooted = [1.BigInt, 1.BigInt /*...*/];

void tree(in uint br, in uint n, in uint l, in uint inSum,
          in BigInt cnt) nothrow {
    __gshared static BigInt[nBranches] c;

    uint sum = inSum;
    foreach (immutable b; br + 1 .. nBranches + 1) {
        sum += n;
        if (sum > nMax || (l * 2 >= sum && b >= nBranches))
            return;
        if (b == br + 1) {
            c[br] = rooted[n] * cnt;
        } else {
            c[br] *= rooted[n] + b - br - 1;
            c[br] /= b - br;
        }
        if (l * 2 < sum)
            unrooted[sum] += c[br];
        if (b < nBranches)
            rooted[sum] += c[br];
        foreach_reverse (immutable m; 1 .. n)
            tree(b, m, l, sum, c[br]);
    }
}

void bicenter(in uint s) nothrow {
    if ((s & 1) == 0)
        unrooted[s] += rooted[s / 2] * (rooted[s / 2] + 1) / 2;
}

void main() {
    foreach (immutable n; 1 .. nMax + 1) {
        tree(0, n, n, 1, 1.BigInt);
        n.bicenter;
        writeln(n, ": ", unrooted[n]);
    }
}
