string makeList(string seperator) {
    int counter = 1;

    string makeItem(string item) {
        import std.conv : to;
        return to!string(counter++) ~ seperator ~ item ~ "\n";
    }

    return makeItem("first") ~ makeItem("second") ~ makeItem("third");
}

void main() {
    import std.stdio : writeln;
    writeln(makeList(". "));
}
