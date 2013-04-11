import std.stdio, std.random, std.typecons, std.conv, std.string;

void main() {
    immutable interval = tuple(1, 100);

    writefln("Guess my target number that is between " ~
             "%d and %d (inclusive).\n", interval.tupleof);
    immutable target = uniform!"[]"(interval.tupleof);

    int answer = -1;
    for (int i = 1; ; i++) {
        writef("Your guess(%d): ", i);
        immutable string txt = stdin.readln().strip();
        try {
            answer = to!int(txt);
        } catch (ConvException e) {
            writefln("  I don't understand your input '%s'?", txt);
            continue;
        }
        if (answer < interval[0] || answer > interval[1]) {
            writeln("  Out of range!");
            continue;
        }
        if (answer == target) {
            writeln("  Ye-Haw!!");
            break;
        }
        writeln(answer < target ? "  Too low." : "  Too high.");
    }

    writeln("\nThanks for playing.");
}
