import std.stdio, std.algorithm, std.file, std.string;

void main() {
    char[] keys = cast(char[])"unixdict.txt".read;
    immutable vals = keys.idup;
    string[][string] anags;
    foreach (w; keys.splitter) {
        immutable k = cast(string)w.representation.sort().release;
        anags[k] ~= vals[k.ptr-keys.ptr .. k.ptr-keys.ptr + k.length];
    }
    immutable m = anags.byValue.map!q{ a.length }.reduce!max;
    writefln("%(%s\n%)", anags.byValue.filter!(ws => ws.length == m));
}
