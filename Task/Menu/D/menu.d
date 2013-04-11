import std.stdio, std.conv, std.string, std.array;

string menuSelect(in string[] entries) {
    static int validChoice(in string input,
                           in int nEntries) pure nothrow {
        try {
            immutable n = to!int(input);
            return (n >= 0 && n <= nEntries) ? n : -1;
        } catch (Exception e) // very generic
            return -1; // not valid
    }

    if (entries.empty)
        return "";

    while (true) {
        writeln("Choose one:");
        foreach (i, const string entry; entries)
            writefln("  %d) %s", i, entry);
        writef("> ");
        immutable input = readln().chomp();
        immutable choice = validChoice(input, entries.length-1);
        if (choice != -1)
            return entries[choice]; // we have a valid choice
        else
            writeln("Wrong choice.");
    }
}

void main() {
    immutable items = ["fee fie", "huff and puff",
                       "mirror mirror", "tick tock"];
    writeln("You chose '", menuSelect(items), "'.");
}
