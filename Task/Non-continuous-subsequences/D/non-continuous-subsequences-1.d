import std.stdio;

T[][] ncsub(T)(in T[] seq, in int s=0) pure nothrow {
    if (seq.length) {
        T[][] aux;
        foreach (ys; ncsub(seq[1..$], s + !(s % 2)))
            aux ~= seq[0] ~ ys;
        return aux ~ ncsub(seq[1..$], s + s % 2);
    } else
        return new T[][](s >= 3, 0);
}

void main() {
    writeln(ncsub([1, 2, 3]));
    writeln(ncsub([1, 2, 3, 4]));
    foreach (nc; ncsub([1, 2, 3, 4, 5]))
        writeln(nc);
}
