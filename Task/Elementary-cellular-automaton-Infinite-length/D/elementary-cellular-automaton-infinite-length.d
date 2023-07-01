import std.stdio, std.array, std.range, std.typecons, std.string, std.conv,
       std.algorithm;
alias R = replicate;

void main() {
    enum nLines = 25;
    enum notCell = (in char c) pure => (c == '1') ? "0" : "1";

    foreach (immutable rule; [90, 30]) {
        writeln("\nRule: ", rule);
        immutable ruleBits = "%08b".format(rule).retro.text;
        const neighs2next = 8.iota
                            .map!(n => tuple("%03b".format(n), [ruleBits[n]]))
                            .assocArray;

        string C = "1";
        foreach (immutable i; 0 .. nLines) {
            writefln("%2d: %s%s", i, " ".R(nLines - i), C.tr("01", ".#"));
            C = notCell(C[0]).R(2) ~ C ~ notCell(C[$ - 1]).R(2);
            C = iota(1, C.length - 1)
                .map!(i => neighs2next[C[i - 1 .. i + 2]])
                .join;
        }
    }
}
