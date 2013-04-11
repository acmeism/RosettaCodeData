import std.stdio, std.array;

void main() {
    enum int max = 12;
    write("  | ");
    foreach (row; 1 .. max+1)
        writef("%4d", row);
    writeln();
    writeln("--+-", "-".replicate(max * 4));
    foreach (row; 1 .. max+1) {
        writef("%2d", row);
        write("| ");
        foreach (column; 1 .. max+1) {
            if (column < row)
                write("    ");
            else
                writef("%4d", row * column);
        }
        writeln();
    }
}
