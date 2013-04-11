import std.stdio, std.algorithm;

void main() {
    auto data = [7.0, 6.0, 5.0, 4.0, 3.0, 2.0, 1.0, 0.0];
    auto indexes = [6, 1, 1, 7]; // One duplicated added to test.

    // Remove duplicates, in place:
    indexes.length -= indexes.sort().uniq().copy(indexes).length;

    foreach (i, idx; indexes)
        swap(data[i], data[idx]);

    data[0 .. indexes.length].sort();

    foreach_reverse (i, idx; indexes)
        swap(data[idx], data[i]);

    assert(data == [7.0, 0.0, 5.0, 4.0, 3.0, 2.0, 1.0, 6.0]);
}
