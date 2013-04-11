import std.stdio;

void main(string[] args) {
    scope(exit)
        writeln("Gone");

    if (args[1] == "throw")
        throw new Exception("message");

    scope(exit)
        writeln("Gone, but we passed the first" ~
                " chance to throw an exception.");
}
