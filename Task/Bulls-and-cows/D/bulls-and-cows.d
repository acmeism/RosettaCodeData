void main() {
    import std.stdio, std.random, std.string, std.algorithm,
           std.range, std.ascii;

    immutable hidden = "123456789"d.randomCover.take(4).array;
    "Enter 'q' at any time to quit\n".writeln;
    while (true) {
        "Next guess: ".write;
        const d = readln.strip.array.sort().release;
        if (d == "q") return;
        if (d.count == 4 && d.all!isDigit && d.uniq.count == 4) {
            immutable bulls = d.zip(hidden).count!q{ a[0] == a[1] },
                      cows = d.count!(g => hidden.canFind(g)) - bulls;
            if (bulls == 4)
                return " You guessed it!".writeln;
            writefln("bulls %d, cows %d", bulls, cows);
        }
        " Bad guess! (4 unique digits, 1-9)".writeln;
    }
}
