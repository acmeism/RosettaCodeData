import std.stdio;
import std.algorithm;

void quickSort(T)(T[] items)
{
    if (items.length >= 2) {
        auto parts = partition3(items, items[$ / 2]);
        quickSort(parts[0]);
        quickSort(parts[2]);
    }
}

void main()
{
    auto items = [4, 65, 2, -31, 0, 99, 2, 83, 782, 1];
    quickSort(items);
    writeln(items);
}
