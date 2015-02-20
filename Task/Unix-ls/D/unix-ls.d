void main() {
    import std.stdio, std.file, std.path;

    foreach (const string path; dirEntries(getcwd, SpanMode.shallow))
        path.baseName.writeln;
}
