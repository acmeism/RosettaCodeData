import std.stdio;

void main() {
    auto file = File("new.txt", "wb");
    file.writeln("Hello World!");
}
