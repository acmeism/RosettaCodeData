import std.bigint;
import std.stdio;

void main() {
    report("25420294593250030202636073700053352635053786165627414518");
    report(0x61);
    report(0x626262);
    report(0x636363);
    report("0x73696d706c792061206c6f6e6720737472696e67");
    report(0x516b6fcd0f);
    report("0xbf4f89001e670274dd");
    report(0x572e4794);
    report("0xecac89cad93923c02321");
    report(0x10c8511e);
}

void report(T)(T v) {
    import std.traits;
    static if (isIntegral!T) {
        enum format = "%#56x -> %s";
    } else {
        enum format = "%56s -> %s";
    }
    writefln(format, v, v.toBase58);
}

string toBase58(T)(T input) {
    import std.traits;
    static if (isSomeString!T) {
        return toBase58(BigInt(input));
    } else {
        import std.algorithm.mutation : reverse;
        import std.array : appender;
        enum ALPHABET = "123456789ABCDEFGHJKLMNPQRSTUVWXYZabcdefghijkmnopqrstuvwxyz";

        auto sb = appender!(char[]);
        size_t mod;

        do {
            mod = cast(size_t) (input % ALPHABET.length);
            sb.put(ALPHABET[mod]);

            input /= ALPHABET.length;
        } while (input);

        sb.data.reverse;
        return sb.data.idup;
    }
}
