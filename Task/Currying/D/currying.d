void main() {
    import std.stdio, std.functional;

    int add(int a, int b) {
        return a + b;
    }

    alias add2 = curry!(add, 2);
    writeln("Add 2 to 3: ", add(2, 3));
    writeln("Add 2 to 3 (curried): ", add2(3));
}
