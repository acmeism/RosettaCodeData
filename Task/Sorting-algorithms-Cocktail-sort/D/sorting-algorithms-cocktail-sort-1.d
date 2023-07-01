// Written in the D programming language.
module rosettaCode.sortingAlgorithms.cocktailSort;

import std.range;

Range cocktailSort(Range)(Range data)
if (isRandomAccessRange!Range && hasLvalueElements!Range) {
    import std.algorithm : swap;
    bool swapped = void;
    void trySwap(E)(ref E lhs, ref E rhs) {
        if (lhs > rhs) {
            swap(lhs, rhs);
            swapped = true;
        }
    }

    if (data.length > 0) do {
        swapped = false;
        foreach (i; 0 .. data.length - 1)
            trySwap(data[i], data[i + 1]);
        if (!swapped)
            break;
        swapped = false;
        foreach_reverse (i; 0 .. data.length - 1)
            trySwap(data[i], data[i + 1]);
    } while(swapped);
    return data;
}

unittest {
    assert (cocktailSort([3, 1, 5, 2, 4]) == [1, 2, 3, 4, 5]);
    assert (cocktailSort([1, 2, 3, 4, 5]) == [1, 2, 3, 4, 5]);
    assert (cocktailSort([5, 4, 3, 2, 1]) == [1, 2, 3, 4, 5]);
    assert (cocktailSort((int[]).init)    == []);
    assert (cocktailSort(["John", "Kate", "Zerg", "Alice", "Joe", "Jane"]) ==
        ["Alice", "Jane", "Joe", "John", "Kate", "Zerg"]);
}
