import std.stdio;

void main() {
    auto source = "gHHH5YY++///\\";

    char prev = source[0];
    foreach(ch; source) {
        if (prev != ch) {
            prev = ch;
            write(", ");
        }
        write(ch);
    }
    writeln();
}
