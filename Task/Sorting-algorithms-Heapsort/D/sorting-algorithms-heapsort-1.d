import std.stdio, std.container;

void heapSort(T)(T[] data) /*pure nothrow @safe @nogc*/ {
    for (auto h = data.heapify; !h.empty; h.removeFront) {}
}

void main() {
   auto items = [7, 6, 5, 9, 8, 4, 3, 1, 2, 0];
   items.heapSort;
   items.writeln;
}
