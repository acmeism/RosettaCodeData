import std.stdio, std.algorithm, std.array, std.traits;

void circlesort(T)(T[] items) if (isMutable!T) {
    uint inner(size_t lo, size_t hi, uint swaps) {
        if (lo == hi)
            return swaps;
        auto high = hi;
        auto low = lo;
        immutable mid = (hi - lo) / 2;

        while (lo < hi) {
            if (items[lo] > items[hi]) {
                swap(items[lo], items[hi]);
                swaps++;
            }
            lo++;
            hi--;
        }

        if (lo == hi && items[lo] > items[hi + 1]) {
            swap(items[lo], items[hi + 1]);
            swaps++;
        }
        swaps = inner(low, low + mid, swaps);
        swaps = inner(low + mid + 1, high, swaps);
        return swaps;
    }

    if (!items.empty)
        while (inner(0, items.length - 1, 0)) {}
}

void main() {
    import std.random, std.conv;

    auto a = [5, -1, 101, -4, 0, 1, 8, 6, 2, 3];
    a.circlesort;
    a.writeln;
    assert(a.isSorted);

    // Fuzzy test.
    int[30] items;
    foreach (immutable _; 0 .. 100_000) {
        auto data = items[0 .. uniform(0, items.length)];
        foreach (ref x; data)
            x = uniform(-items.length.signed * 3, items.length.signed * 3);
        data.circlesort;
        assert(data.isSorted);
    }
}
