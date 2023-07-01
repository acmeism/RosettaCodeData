T[] forwardDifference(T)(in T[] data, in int level) pure nothrow
in {
    assert(level >= 0 && level < data.length);
} body {
    auto result = data.dup;
    foreach (immutable i; 0 .. level)
        foreach (immutable j, ref el; result[0 .. $ - i - 1])
            el = result[j + 1] - el;
    result.length -= level;
    return result;
}

void main() {
    import std.stdio;

    const data = [90.5, 47, 58, 29, 22, 32, 55, 5, 55, 73.5];
    foreach (immutable level; 0 .. data.length)
        forwardDifference(data, level).writeln;
}
