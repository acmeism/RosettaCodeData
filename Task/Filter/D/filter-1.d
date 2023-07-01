void main() {
    import std.algorithm: filter, equal;

    immutable data = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10];
    auto evens = data.filter!(x => x % 2 == 0); // Lazy.
    assert(evens.equal([2, 4, 6, 8, 10]));
}
