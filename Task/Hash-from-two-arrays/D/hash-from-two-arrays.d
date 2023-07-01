void main() {
    import std.array, std.range;

    immutable hash = ["a", "b", "c"].zip([1, 2, 3]).assocArray;
}
