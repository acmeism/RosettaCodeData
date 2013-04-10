import std.stdio, std.algorithm, std.file;

void main() {
    char[] keys = cast(char[])read("unixdict.txt");
    string vals = keys.idup;
    string[][string] anags;
    foreach (w; std.array.splitter(keys)) {
        const k = cast(string)sort(cast(ubyte[])w).release();
        anags[k] ~= vals[k.ptr-keys.ptr .. k.ptr-keys.ptr + k.length];
    }
    immutable m = anags.byValue.map!(ws => ws.length)().reduce!max();
    writefln("%(%s\n%)", filter!(ws => ws.length == m)(anags.byValue));
}
