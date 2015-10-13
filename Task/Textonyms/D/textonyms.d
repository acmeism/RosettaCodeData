void main() {
    import std.stdio, std.string, std.range, std.algorithm, std.ascii;

    immutable src = "unixdict.txt";
    const words = src.File.byLineCopy.map!strip.filter!(w => w.all!isAlpha).array;

    immutable table = makeTrans("abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ",
                                "2223334445556667777888999922233344455566677778889999");

    string[][string] dials;
    foreach (const word; words)
        dials[word.translate(table)] ~= word;

    auto textonyms = dials.byPair.filter!(p => p[1].length > 1).array;

    writefln("There are %d words in %s which can be represented by the digit key mapping.", words.length, src);
    writefln("They require %d digit combinations to represent them.", dials.length);
    writefln("%d digit combinations represent Textonyms.", textonyms.length);

    "\nTop 5 in ambiguity:".writeln;
    foreach (p; textonyms.schwartzSort!(p => -p[1].length).take(5))
        writefln("    %s => %-(%s %)", p[]);

    "\nTop 5 in length:".writeln;
    foreach (p; textonyms.schwartzSort!(p => -p[0].length).take(5))
        writefln("    %s => %-(%s %)", p[]);
}
