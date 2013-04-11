import std.stdio;

T[] quickSort(T)(T[] items) {
    if (items.length <= 1)
        return items;
    T[] less, more;
    foreach (x; items[1 .. $])
        (x < items[0] ? less : more) ~= x;
    return quickSort(less) ~ items[0] ~ quickSort(more);
}

void main() {
    writeln(quickSort([4, 65, 2, -31, 0, 99, 2, 83, 782, 1]));
}
