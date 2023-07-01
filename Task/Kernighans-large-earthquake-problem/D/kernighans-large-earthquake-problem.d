import std.conv : to;
import std.regex : ctRegex, split;
import std.stdio : File, writeln;

void main() {
    auto ctr = ctRegex!"\\s+";

    writeln("Those earthquakes with a magnitude > 6.0 are:");
    foreach (line; File("data.txt").byLineCopy) {
        auto parts = split(line, ctr);
        if (parts[2].to!double > 6.0) {
            writeln(line);
        }
    }
}
