void main() {
    import std.stdio, std.file, std.string;
    auto file_lines = readText("input.txt").splitLines();
    //file_lines becomes an array of strings, each line is one element
    writeln((file_lines.length > 6) ? file_lines[6] : "line not found");
}
