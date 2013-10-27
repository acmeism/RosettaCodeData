void main() {
    import std.stdio;

    immutable data = [1, 3, 2, 9, 1, 2, 3, 8, 8, 1, 0, 2];

    bool[int] hash;
    foreach (el; data)
        hash[el] = true;
    hash.byKey.writeln;
}
