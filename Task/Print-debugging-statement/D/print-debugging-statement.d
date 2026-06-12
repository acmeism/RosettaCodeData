import std.stdio;

void debugln(string file = __FILE__, size_t line = __LINE__, S...)(S args) {
    write('[', file, '@', line, "] ", args, '\n');
}

void debugWrite(S...)(S args, string file = __FILE__, size_t line = __LINE__) {
    write('[', file, '@', line, "] ", args, '\n');
}

void main() {
    debugln();
    debugln("Hello world!");
    debugln("Hello", ' ', "world", '!');

    debugWrite();
    debugWrite("Goodbye world!");
    debugWrite("Goodbye", ' ', "world", '!');
}
