import std.stdio, std.algorithm, std.range, std.string;

void main() {
    dstring[][dstring] anags;
    foreach (dchar[] w; File("unixdict.txt").lines())
        anags[w.chomp().sort().release().idup] ~= w.chomp().idup;
    immutable m = anags.byValue.map!(ws => ws.length)().reduce!max();
    writefln("%(%s\n%)", anags.byValue.filter!(ws => ws.length == m)());
}
