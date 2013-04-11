import std.stdio, std.algorithm;

void main() {
    auto data = [1, 3, 2, 9, 1, 2, 3, 8, 8, 1, 0, 2];
    data.sort();
    writeln(uniq(data));
}
