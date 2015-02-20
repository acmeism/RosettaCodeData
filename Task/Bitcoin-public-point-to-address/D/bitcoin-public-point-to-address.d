import std.stdio, std.algorithm, std.digest.ripemd, sha_256_2;

// A Bitcoin public point.
struct PPoint { ubyte[32] x, y; }

private enum bitcoinVersion = 0;
private enum RIPEMD160_digest_len = typeof("".ripemd160Of).length;
private alias sha = SHA256.digest;
alias Address = ubyte[1 + 4 + RIPEMD160_digest_len];


/// Returns a base 58 encoded bitcoin address corresponding to the receiver.
char[] toBase58(ref Address a) pure nothrow @safe {
    static immutable symbols = "123456789" ~
                               "ABCDEFGHJKLMNPQRSTUVWXYZ" ~
                               "abcdefghijkmnopqrstuvwxyz";
    static assert(symbols.length == 58);

    auto result = new typeof(return)(34);
    foreach_reverse (ref ri; result) {
        uint c = 0;
        foreach (ref ai; a) {
            immutable d = (c % symbols.length) * 256 + ai;
            ai = d / symbols.length;
            c = d;
        }
        ri = symbols[c % symbols.length];
    }

    size_t i = 1;
    for (; i < result.length && result[i] == '1'; i++) {}
    return result[i - 1 .. $];
}


char[] bitcoinEncode(in ref PPoint p) pure nothrow {
    ubyte[typeof(PPoint.x).length + typeof(PPoint.y).length + 1] s;
    s[0] = 4;
    s[1 .. 1 + p.x.length] = p.x[];
    s[1 + p.x.length .. $] = p.y[];

    Address rmd;
    rmd[0] = bitcoinVersion;
    rmd[1 .. RIPEMD160_digest_len + 1] = s.sha.ripemd160Of;
    rmd[$-4 .. $] = rmd[0 .. RIPEMD160_digest_len + 1].sha.sha[0 .. 4];
    return rmd.toBase58;
}


void main() {
    PPoint p = {
cast(typeof(PPoint.x))
x"50863AD64A87AE8A2FE83C1AF1A8403CB53F53E486D8511DAD8A04887E5B2352",
cast(typeof(PPoint.y))
x"2CD470243453A299FA9E77237716103ABC11A1DF38855ED6F2EE187E9C582BA6"};

    p.bitcoinEncode.writeln;
}
