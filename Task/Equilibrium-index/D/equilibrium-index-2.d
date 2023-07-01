import std.stdio, std.algorithm;

size_t[] equilibrium(T)(in T[] items) @safe pure nothrow {
    size_t[] result;
    T left = 0, right = items.sum;

    foreach (immutable i, e; items) {
        right -= e;
        if (right == left)
            result ~= i;
        left += e;
    }
    return result;
}

void main() {
    [-7, 1, 5, 2, -4, 3, 0].equilibrium.writeln;
}
