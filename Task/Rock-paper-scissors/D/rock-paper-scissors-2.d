import std.stdio, std.random, std.string, std.conv, std.array,
       std.typecons;

enum Choice { rock, paper, scissors }

bool beats(in Choice c1, in Choice c2) pure nothrow {
    return (c1 == Choice.paper    && c2 == Choice.rock) ||
           (c1 == Choice.scissors && c2 == Choice.paper) ||
           (c1 == Choice.rock     && c2 == Choice.scissors);
}

Choice genMove(in int r, in int p, in int s) {
    immutable x = uniform!"[]"(1, r + p + s);
    if (x < s)      return Choice.rock;
    if (x <= s + r) return Choice.paper;
    else            return Choice.scissors;
}

Nullable!To maybeTo(To, From)(From x) {
    try {
        return typeof(return)(x.to!To);
    } catch (ConvException e) {
        return typeof(return)();
    }
}

void main() {
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
        writeln("Player: ", h, " Computer: ", c);

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
