import std.stdio, std.algorithm, std.random;

void shuffle(Range)(Range r) {
    foreach_reverse (i; 1 .. r.length)
        swap(r[i], r[uniform(0, i + 1)]);
}

void main() {
    auto a = [1, 2, 3, 4, 5, 6, 7, 8, 9];
    a.shuffle();
    writeln(a);
}
