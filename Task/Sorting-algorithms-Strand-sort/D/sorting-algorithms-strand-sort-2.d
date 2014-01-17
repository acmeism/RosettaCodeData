import std.stdio, std.array;

T[] strandSort(T)(const(T)[] list) pure nothrow {
    static T[] merge(const(T)[] left, const(T)[] right) pure nothrow {
        T[] res;
        while (!left.empty && !right.empty) {
            if (left.front <= right.front) {
                res ~= left.front;
                left.popFront;
            } else {
                res ~= right.front;
                right.popFront;
            }
        }
        return res ~ left ~ right;
    }

    T[] result;
    while (!list.empty) {
        auto sorted = list[0 .. 1];
        list.popFront;
        typeof(sorted) leftover;
        foreach (const item; list)
            (sorted.back <= item ? sorted : leftover) ~= item;
        result = merge(sorted, result);
        list = leftover;
    }

    return result;
}

void main() {
    const arr = [-2, 0, -2, 5, 5, 3, -1, -3, 5, 5, 0, 2, -4, 4, 2];
    arr.strandSort.writeln;
}
