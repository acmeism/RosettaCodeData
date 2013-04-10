import std.stdio, std.algorithm, std.array;

T[] mode(T)(T[] items) /*pure nothrow*/ {
    int[T] aa;
    foreach (item; items)
        aa[item]++;
    int m = aa.byValue.reduce!max();
    return aa.byKey.filter!(k => aa[k] == m)().array();
}

void main() {
    auto data = [1, 2, 3, 1, 2, 4, 2, 5, 3, 3, 1, 3, 6];
    writeln("Mode: ", data.mode());

    data ~= 2;
    writeln("Mode: ", data.mode());
}
