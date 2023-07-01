import std.stdio;

void main() {
    string sample = "one^|uno||three^^^^|four^^^|^cuatro|";

    writeln(sample);
    writeln(tokenizeString(sample, '|', '^'));
}

auto tokenizeString(string source, char seperator, char escape) {
    import std.array : appender;
    import std.exception : enforce;

    auto output = appender!(string[]);
    auto token = appender!(char[]);

    bool inEsc;
    foreach(ch; source) {
        if (inEsc) {
            inEsc = false;
        } else if (ch == escape) {
            inEsc = true;
            continue;
        } else if (ch == seperator) {
            output.put(token.data.idup);
            token.clear();
            continue;
        }
        token.put(ch);
    }
    enforce(!inEsc, "Invalid terminal escape");

    output.put(token.data.idup);
    return output.data;
}
