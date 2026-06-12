void main() {
    import std.stdio, std.string, std.conv, std.algorithm;

    foreach (immutable _; 0 .. readln.strip.to!uint)
        readln.split.to!(int[]).sum.writeln;
}
