import std.stdio, std.algorithm, std.range, std.array;

auto quickSort(T)(T[] items) /*pure*/ nothrow {
    if (items.length < 2)
        return items;
    auto pivot = items[0];
    return items[1 .. $].filter!(x => x < pivot).array.quickSort ~
           pivot ~
           items[1 .. $].filter!(x => x >= pivot).array.quickSort;
}

void main() {
    [4, 65, 2, -31, 0, 99, 2, 83, 782, 1].quickSort.writeln;
}
