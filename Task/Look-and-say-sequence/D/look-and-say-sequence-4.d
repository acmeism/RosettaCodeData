void main(in string[] args) {
    import std.stdio, std.conv, std.algorithm, std.array, std.string;

    immutable n = (args.length == 2) ? args[1].to!uint : 10;
    if (n == 0)
        return;

    auto seq = ['1'];
    writefln("%2d: n. digits: %d", 1, seq.length);
    foreach (immutable i; 2 .. n + 1) {
        Appender!(typeof(seq)) result;
        foreach (const digit, const count; seq.representation.group) {
            result ~= "123"[count - 1];
            result ~= digit;
        }
        seq = result.data;
        writefln("%2d: n. digits: %d", i, seq.length);
    }
}
