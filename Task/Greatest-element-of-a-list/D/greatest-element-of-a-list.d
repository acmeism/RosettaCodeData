import std.stdio, std.algorithm;

void main() {
    auto items = [9, 4, 3, 8, 5];
    auto m = reduce!max(items);
    writeln(m);
}
