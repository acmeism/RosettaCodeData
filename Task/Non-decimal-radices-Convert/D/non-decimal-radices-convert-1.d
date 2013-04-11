import std.stdio, std.conv, std.string;

void main() {
    "1abcd".to!int(16).writeln();

    toLower(60_272_032_366.to!string(36) ~ " " ~
            591_458.to!string(36)).writeln();
}
