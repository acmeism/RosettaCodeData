import std.stdio;

void main() {
    for (int i = 1; ; i++) {
        write(i);
        if (i >= 10)
            break;
        write(", ");
    }

    writeln();
}
