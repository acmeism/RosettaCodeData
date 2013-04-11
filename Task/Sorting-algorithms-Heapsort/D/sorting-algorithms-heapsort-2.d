import std.stdio, std.container;

void inplaceHeapSort(T)(T[] data) {
    auto h = heapify(data);
    while (!h.empty)
        h.removeFront();
}

void main() {
   auto arr = [7, 6, 5, 9, 8, 4, 3, 1, 2, 0];
   inplaceHeapSort(arr);
   writeln(arr);
}
