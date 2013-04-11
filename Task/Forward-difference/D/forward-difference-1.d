import std.stdio;

T[] forwardDifference(T)(in T[] data, in int level) pure nothrow
    in {
        assert(level >= 0 && level < data.length);
    } body {
        //auto result = data.dup; // not nothrow
        auto result = data ~ []; // slower
        foreach (i; 0 .. level)
            foreach (j, ref el; result[0 .. $ - i - 1])
                el = result[j + 1] - el;
        result.length -= level;
        return result;
    }

void main() {
    auto data = [90.5, 47, 58, 29, 22, 32, 55, 5, 55, 73.5];
    foreach (level; 0 .. data.length)
        writeln(forwardDifference(data, level));
}
