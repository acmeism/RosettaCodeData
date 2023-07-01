import std.stdio, std.random, std.algorithm, std.range;

T quickSelect(T)(T[] arr, size_t n)
in {
    assert(n < arr.length);
} body {
    static size_t partition(T[] sub, in size_t pivot) pure nothrow
    in {
        assert(!sub.empty);
        assert(pivot < sub.length);
    } body {
        auto pivotVal = sub[pivot];
        sub[pivot].swap(sub.back);
        size_t storeIndex = 0;
        foreach (ref si; sub[0 .. $ - 1]) {
            if (si < pivotVal) {
                si.swap(sub[storeIndex]);
                storeIndex++;
            }
        }
        sub.back.swap(sub[storeIndex]);
        return storeIndex;
    }

    size_t left = 0;
    size_t right = arr.length - 1;
    while (right > left) {
        assert(left < arr.length);
        assert(right < arr.length);
        immutable pivotIndex = left + partition(arr[left .. right + 1],
            uniform(0U, right - left + 1));
        if (pivotIndex - left == n) {
            right = left = pivotIndex;
        } else if (pivotIndex - left < n) {
            n -= pivotIndex - left + 1;
            left = pivotIndex + 1;
        } else {
            right = pivotIndex - 1;
        }
    }

    return arr[left];
}

void main() {
    auto a = [9, 8, 7, 6, 5, 0, 1, 2, 3, 4];
    a.length.iota.map!(i => a.quickSelect(i)).writeln;
}
