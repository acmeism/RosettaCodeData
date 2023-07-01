import std.stdio, std.random, std.string, std.conv, std.array, std.typecons;

enum Choice { rock, paper, scissors }

bool beats(in Choice c1, in Choice c2) pure nothrow @safe @nogc {
    with (Choice) return (c1 == paper    && c2 == rock) ||
                         (c1 == scissors && c2 == paper) ||
                         (c1 == rock     && c2 == scissors);
}

Choice genMove(in int r, in int p, in int s) @safe /*@nogc*/ {
    immutable x = uniform!"[]"(1, r + p + s);
    if (x < s)      return Choice.rock;
    if (x <= s + r) return Choice.paper;
    else            return Choice.scissors;
}

Nullable!To maybeTo(To, From)(From x) pure nothrow @safe {
    try {
        return typeof(return)(x.to!To);
    } catch (ConvException) {
        return typeof(return)();
    } catch (Exception e) {
        static immutable err = new Error("std.conv.to failure");
        throw err;
    }
}

void main() /*@safe*/ {
    int r = 1, p = 1, s = 1;

    while (true) {
        write("rock, paper or scissors? ");
        immutable hs = readln.strip.toLower;
        if (hs.empty)
            break;

        immutable h = hs.maybeTo!Choice;
        if (h.isNull) {
            writeln("Wrong input: ", hs);
            continue;
        }

        immutable c = genMove(r, p, s);
        writeln("Player: ", h.get, " Computer: ", c);

             if (beats(h, c)) writeln("Player wins\n");
        else if (beats(c, h)) writeln("Player loses\n");
        else                  writeln("Draw\n");

        final switch (h.get) {
            case Choice.rock:     r++; break;
            case Choice.paper:    p++; break;
            case Choice.scissors: s++; break;
        }
    }
}
