import std.stdio: writeln;

T sumSquares(T)(T[] a) {
    T sum = 0;
    foreach (e; a)
        sum += e ^^ 2;
    return sum;
}

void main() {
    auto items = [3.1, 1.0, 4.0, 1.0, 5.0, 9.0];
    writeln(sumSquares(items));
}
