import std.stdio, std.string, std.algorithm, std.conv;

void main() {
    const perms = "ABCD CABD ACDB DACB BCDA ACBD ADCB CDAB DABC
                   BCAD CADB CDBA CBAD ABDC ADBC BDCA DCBA BACD
                   BADC BDAC CBDA DBCA DCAB".split();

    // Version 1: XOR all the ASCII values, the uneven one gets
    // flushed out; based on Perl 6 (via Go)
    ubyte[4] b;
    foreach (perm; perms)
        foreach (i, c; perm)
            b[i] ^= c;
    writeln(cast(char[])b);

    // Version 2 : Sum ASCII values
    auto sumr = perms[0].reduce!q{a + b}(); // sum row
    foreach (i; 0 .. 4) {
        // sum columns
        const sumc = reduce!((a,b)=> text(to!int(a) + b[i]))("0",perms);
        // see how much it falls short
        write(cast(char)(sumr - to!int(sumc) % sumr));
    }
    writeln();

    // Version 3: some sort of checksum, don't ask
    // me: translation of Java
    enum int len = 4;
    int maxCode = len - 1;
    foreach_reverse (i; 3 .. len + 1)
        maxCode *= i; // maxCode will be 36
    foreach (i; 0 .. len) {
        int code = 0;
        foreach (p; perms)
            code += perms[0].countUntil(p[i]);

        // code will come up 3, 1, 0, 2 short of 36
        write(cast(char)perms[0][maxCode - code]);
    }
}
