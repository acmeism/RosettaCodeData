T[][] ncsub(T)(in T[] seq, in uint s=0) pure nothrow @safe {
    if (seq.length) {
        typeof(return) aux;
        foreach (ys; ncsub(seq[1 .. $], s + !(s % 2)))
            aux ~= seq[0] ~ ys;
        return aux ~ ncsub(seq[1 .. $], s + s % 2);
    } else
        return new typeof(return)(s >= 3, 0);
}

void main() @safe {
    import std.stdio;

    [1, 2, 3].ncsub.writeln;
    [1, 2, 3, 4].ncsub.writeln;
    foreach (const nc; [1, 2, 3, 4, 5].ncsub)
        nc.writeln;
}
