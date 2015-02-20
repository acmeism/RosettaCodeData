import std.algorithm, std.range, std.array;

void main() {
    auto data = [7, 6, 5, 4, 3, 2, 1, 0];
    auto indices = [6, 1, 7];

    data.indexed(indices.sort()).sort();

    assert(data == [7, 0, 5, 4, 3, 2, 1, 6]);
}
