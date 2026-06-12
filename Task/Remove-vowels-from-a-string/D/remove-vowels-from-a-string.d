import std.stdio;

void print_no_vowels(string s) {
    foreach (c; s) {
        switch (c) {
            case 'A', 'E', 'I', 'O', 'U':
            case 'a', 'e', 'i', 'o', 'u':
                break;
            default:
                write(c);
        }
    }
    writeln;
}

void main() {
    print_no_vowels("D Programming Language");
}
