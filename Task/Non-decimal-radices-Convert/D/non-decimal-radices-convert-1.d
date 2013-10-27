import std.stdio, std.conv, std.string, std.ascii;

void main() {
    "1abcd".to!int(16).writeln;

    writeln(60_272_032_366.to!string(36, LetterCase.lower), ' ',
            591_458.to!string(36, LetterCase.lower));
}
