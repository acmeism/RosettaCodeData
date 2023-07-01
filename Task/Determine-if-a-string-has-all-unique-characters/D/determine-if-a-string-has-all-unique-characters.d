import std.stdio;

void uniqueCharacters(string str) {
    writefln("input: `%s`, length: %d", str, str.length);
    foreach (i; 0 .. str.length) {
        foreach (j; i + 1 .. str.length) {
            if (str[i] == str[j]) {
                writeln("String contains a repeated character.");
                writefln("Character '%c' (hex %x) occurs at positions %d and %d.", str[i], str[i], i + 1, j + 1);
                writeln;
                return;
            }
        }
    }
    writeln("String contains no repeated characters.");
    writeln;
}

void main() {
    uniqueCharacters("");
    uniqueCharacters(".");
    uniqueCharacters("abcABC");
    uniqueCharacters("XYZ ZYX");
    uniqueCharacters("1234567890ABCDEFGHIJKLMN0PQRSTUVWXYZ");
}
