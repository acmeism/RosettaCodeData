import std.stdio, std.array;

T[] quickSort(T)(T[] items) pure nothrow {
    if (items.empty)
        return items;
    T[] less, notLess;
    foreach (x; items[1 .. $])
        (x < items[0] ? less : notLess) ~= x;
    return less.quickSort ~ items[0] ~ notLess.quickSort;
}

void main() {
    [4, 65, 2, -31, 0, 99, 2, 83, 782, 1].quickSort.writeln;
}
