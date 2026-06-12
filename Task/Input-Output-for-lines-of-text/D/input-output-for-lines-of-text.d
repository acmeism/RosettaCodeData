void main() {
    import std.stdio, std.conv, std.string;

    enum doStuff = (in string line) => line.write;

    foreach (_; 0 .. readln.strip.to!uint)
        doStuff(readln.idup);
}
