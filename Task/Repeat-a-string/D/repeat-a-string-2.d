import std.stdio;

void main() {
    char[] chars;     // create the dynamic array
    chars.length = 5; // set the length
    chars[] = '*';    // set all characters in the string to '*'
    writeln(chars);
}
