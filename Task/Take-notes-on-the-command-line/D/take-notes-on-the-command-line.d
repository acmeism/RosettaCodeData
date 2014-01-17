import std.stdio, std.file, std.string, std.datetime, std.range;

void main(string[] args) {
    immutable filename = "NOTES.TXT";

    if (args.length == 1) {
        if (exists(filename) && isFile(filename))
            writefln("%-(%s\n%)", filename.File.byLine);
    } else {
        auto f = File(filename, "a+");
        f.writefln("%s", cast(DateTime)Clock.currTime);
        f.writefln("\t%s", args.dropOne.join(" "));
    }
}
