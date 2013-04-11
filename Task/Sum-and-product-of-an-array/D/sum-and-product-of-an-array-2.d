import std.stdio, std.algorithm, std.typecons;

void main() {
    immutable array = [1, 2, 3, 4, 5];

    // Results are stored in a 2-tuple
    immutable r = reduce!(q{a + b}, q{a * b})(tuple(0, 1), array);

    writeln("Sum: ", r[0]);
    writeln("Product: ", r[1]);
}
