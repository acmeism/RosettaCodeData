import std.stdio, std.algorithm, std.range;

int lDistR(T)(in T[] a, in T[] b) /*pure nothrow*/ {
    if (a.length == 0)
        return b.length;
    if (b.length == 0)
        return a.length;
    if (a.length == b.length) {
        auto r = iota(a.length);
        auto u = r.until!(i => a[i] != b[i])();
        if (equal(r, u)) // u is a short-circuit test until any
                         // mismatch
            return 0;    // u is equivalent to r, means no
                         // mismatch found
    }

    const(T)[][] candidate;
    immutable alen = a.length;
    immutable blen = b.length;
    // mutate _a_ by 1 edit to create members of candidate

    // delete an _a_ element
    if (alen > blen)
        foreach (i; 0 .. alen)
            candidate ~= a[0 .. i] ~ a[i+1 .. $];
    // insert matching _b_ element to _a_
    if (alen < blen) {
        foreach (i; 0 .. alen+1) // from left
            candidate ~=  a[0 .. i] ~ b[i] ~ a[i .. $];
        foreach (i; 0 .. alen+1) // from right
            candidate ~=  a[0 .. $-i] ~ b[$ - i - 1] ~ a[$-i .. $];
    }
    // subsistute matching _a_ element with _b_'s
    if (alen == blen)
        foreach (i; 0 .. alen)
            if (a[i] != b[i])
                candidate ~= a[0..i] ~ b[i] ~ a[i+1 .. $];

    // exclusive cases, so only 1 edit is make to create each
    // new candidate

    // minimum distance on this run
    return candidate.map!(e => lDistR(e, b) + 1)().reduce!min();
}

void main() {
    writeln(lDistR("kitten", "sitting"));
}
