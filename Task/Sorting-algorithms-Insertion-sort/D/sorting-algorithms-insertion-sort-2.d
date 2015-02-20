import std.stdio, std.range, std.algorithm, std.traits;

void insertionSort(R)(R arr)
if (hasLength!R && isRandomAccessRange!R && hasSlicing!R) {
    foreach (immutable i; 1 .. arr.length)
        bringToFront(arr[0 .. i].assumeSorted.upperBound(arr[i]), arr[i .. i + 1]);
}

void main() {
    import std.random, std.container;

    auto arr1 = [28, 44, 46, 24, 19, 2, 17, 11, 25, 4];
    arr1.insertionSort;
    assert(arr1.isSorted);
    writeln("arr1 sorted: ", arr1);

    auto arr2 = Array!int([28, 44, 46, 24, 19, 2, 17, 11, 25, 4]);
    arr2[].insertionSort;
    assert(arr2[].isSorted);
    writeln("arr2 sorted: ", arr2[]);

    // Random data test.
    int[10] buf;
    foreach (immutable _; 0 .. 100_000) {
        auto arr3 = buf[0 .. uniform(0, $)];
        foreach (ref x; arr3)
            x = uniform(-6, 6);
        arr3.insertionSort;
        assert(arr3.isSorted);
    }
}
