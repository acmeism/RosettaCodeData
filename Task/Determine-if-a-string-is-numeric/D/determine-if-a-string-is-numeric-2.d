import std.stdio, std.string, std.conv, std.array, std.exception;

bool isNumeric(in string s) pure {
    immutable s2 = s.strip.toLower.replace("_", "").replace(",", "");
    try {
        s2.to!real;
    } catch (ConvException e) {
        if (s2.startsWith("0x"))
            return !s2[2 .. $].to!ulong(16)
                    .collectException!ConvException;
        else if (s2.startsWith("0b"))
            return !s2[2 .. $].to!ulong(2)
                    .collectException!ConvException;
        else
            return false;
    }

    return true;
}

void main() {
    foreach (immutable s; ["12", " 12\t", "hello12", "-12", "02",
                 "0-12", "+12", "1.5", "1,000", "1_000",
                 "0x10", "0b10101111_11110000_11110000_00110011",
                 "-0b10101", "0x10.5"])
        writefln(`isNumeric("%s"): %s`, s, s.isNumeric);
}
