import std.stdio, std.string, std.array;

void main() {
    foreach (const s; ["12", " 12\t", "hello12", "-12", "02"
                 "0-12", "+12", "1.5", "1,000", "1_000",
                 "0x10", "0b10101111_11110000_11110000_00110011",
                 "-0b10101", "0x10.5"])
        writefln(`isNumeric("%s"): %s`, s, s.strip().isNumeric(true));
}
