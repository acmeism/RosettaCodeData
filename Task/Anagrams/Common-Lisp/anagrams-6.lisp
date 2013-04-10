import std.stdio, std.stream, tools.functional, tools.base;

void main() {
  ( (new BufferedFile("/usr/share/dict/cracklib-small"))
    /map/ ex!("s -> s.dup")
    /groupby/ ex!("s -> s.dup.sort")
    /map/ (string key, string[] value) { return value; }
    /qsort/ ex!("a, b -> a.length < b.length")
  )[$-1].writefln();
}
