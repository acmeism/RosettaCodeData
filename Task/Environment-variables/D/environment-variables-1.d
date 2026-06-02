import std.stdio, std.process;

void main() {
    auto home = environment.get("HOME");
    writeln(home);
}
