import std.stdio, std.algorithm;

void main() {
    auto items = [1, 2, 3];
    do
        writeln(items);
    while (items.nextPermutation());
}
