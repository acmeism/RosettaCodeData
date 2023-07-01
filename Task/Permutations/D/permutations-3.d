void main() {
    import std.stdio, std.algorithm;

    auto items = [1, 2, 3];
    do
        items.writeln;
    while (items.nextPermutation);
}
