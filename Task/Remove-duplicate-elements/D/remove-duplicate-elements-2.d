import std.stdio;

void main() {
    auto data = [1, 3, 2, 9, 1, 2, 3, 8, 8, 1, 0, 2];

    int[int] hash;
    foreach (el; data)
        hash[el] = 0;
    writeln(hash.keys);
}
