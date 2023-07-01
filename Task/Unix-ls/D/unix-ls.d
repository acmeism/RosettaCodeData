void main() {
    import std.stdio, std.file, std.path, std.array, std.algorithm;

    foreach (const string path; dirEntries(getcwd, SpanMode.shallow).array.sort)
        path.baseName.writeln;
}
