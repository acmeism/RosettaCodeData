void main() {
    import std.stdio;

    foreach (line; "read_a_file_line_by_line.d".File.byLine)
        line.writeln;
}
