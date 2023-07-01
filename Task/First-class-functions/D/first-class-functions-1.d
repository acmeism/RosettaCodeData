void main() {
    import std.stdio, std.math, std.typetuple, std.functional;

    alias dir = TypeTuple!(sin,  cos,  x => x ^^ 3);
    alias inv = TypeTuple!(asin, acos, cbrt);
    // foreach (f, g; staticZip!(dir, inv))
    foreach (immutable i, f; dir)
        writefln("%6.3f", compose!(f, inv[i])(0.5));
}
