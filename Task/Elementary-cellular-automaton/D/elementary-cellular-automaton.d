import std.stdio, std.string, std.conv, std.range, std.algorithm, std.typecons;

enum mod = (in int n, in int m) pure nothrow @safe @nogc => ((n % m) + m) % m;

struct ECAwrap {
    public string front;
    public enum bool empty = false;
    private immutable const(char)[string] next;

    this(in string cells_, in uint rule) pure @safe {
        this.front = cells_;
        immutable ruleBits = "%08b".format(rule).retro.text;
        next = 8.iota.map!(n => tuple("%03b".format(n), char(ruleBits[n]))).assocArray;
    }

    void popFront() pure @safe {
        alias c = front;
        c = iota(c.length)
            .map!(i => next[[c[(i - 1).mod($)], c[i], c[(i + 1) % $]]])
            .text;
    }
}

void main() @safe {
    enum nLines = 50;
    immutable string start = "0000000001000000000";
    immutable uint[] rules = [90, 30, 122];
    writeln("Rules: ", rules);
    auto ecas = rules.map!(rule => ECAwrap(start, rule)).array;

    foreach (immutable i; 0 .. nLines) {
        writefln("%2d: %-(%s    %)", i, ecas.map!(eca => eca.front.tr("01", ".#")));
        foreach (ref eca; ecas)
            eca.popFront;
    }
}
