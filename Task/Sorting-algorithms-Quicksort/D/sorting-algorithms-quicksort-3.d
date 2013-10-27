import std.stdio, std.algorithm;

void quickSort(T)(T[] items) pure nothrow {
    if (items.length >= 2) {
        auto parts = partition3(items, items[$ / 2]);
        parts[0].quickSort;
        parts[2].quickSort;
    }
}

void main() {
    auto items = [4, 65, 2, -31, 0, 99, 2, 83, 782, 1];
    items.quickSort;
    items.writeln;
}
