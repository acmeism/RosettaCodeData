import std.stdio, std.conv, std.string;

void main() {
    int nRow, nCol;

    write("Give me the numer of rows: ");
    try {
        nRow = readln().strip().to!int();
    } catch (StdioException e) {
        nRow = 3;
        writeln();
    }

    write("Give me the numer of columns: ");
    try {
        nCol = to!int(readln().strip());
    } catch (StdioException e) {
        nCol = 5;
        writeln();
    }

    auto array = new float[][](nRow, nCol);
    array[0][0] = 3.5;
    writeln("The number at place [0, 0] is ", array[0][0]);
}
