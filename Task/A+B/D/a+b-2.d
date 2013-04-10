import std.stdio, std.conv, std.string;

void main() {
    auto fin = File("sum_input.txt", "r");
    auto r = fin.readln().split();
    auto fout = File("sum_output.txt", "w");
    fout.writeln(to!int(r[0]) + to!int(r[1]));
}
