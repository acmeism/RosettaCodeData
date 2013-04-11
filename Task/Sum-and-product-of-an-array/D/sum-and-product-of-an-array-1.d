import std.stdio;

void main() {
    immutable array = [1, 2, 3, 4, 5];

    int sum = 0;
    int prod = 1;

    foreach (x; array) {
        sum += x;
        prod *= x;
    }

    writeln("Sum: ", sum);
    writeln("Product: ", prod);
}
