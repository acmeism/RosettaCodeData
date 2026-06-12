import std.stdio, std.conv, std.array, std.string, std.range, std.algorithm, std.typecons;

immutable string[string] hex2bin, bin2hex;

shared static this() pure @safe {
    hex2bin = 16.iota.map!(x => tuple("%x".format(x), "%04b".format(x))).assocArray;
    bin2hex = 16.iota.map!(x => tuple("%b".format(x), "%x".format(x))).assocArray;
}

string dec2bin(real d) pure @safe {
    immutable neg = d < 0;
    if (neg)
        d = -d;
    immutable hx = "%a".format(d);
    immutable p = hx.countUntil('p');
    immutable bn = hx[2 .. p].split("").map!(ch => hex2bin.get(ch, ch)).join;
    // Currently Phobos lacks a strip(string, string) function.
    // return (neg ? "-" : "") ~ bn.strip("0")
    return (neg ? "-" : "") ~ bn.tr("0", " ").strip.tr(" ", "0")
           ~ hx[p .. p + 2] ~ "%b".format(hx[p + 2 .. $].to!int);
}

real bin2dec(string bn) pure /*@safe*/
in {
    assert(!bn.empty);
} do {
    immutable neg = bn[0] == '-';
    if (neg)
        bn = bn[1 .. $];
    immutable dp1 = bn.countUntil('.');
    immutable extra0a = "0".replicate(4 - dp1 % 4);
    immutable bn2 = extra0a ~ bn;
    immutable dp2 = bn2.countUntil('.');
    immutable p = bn2.countUntil('p');
    auto hx = iota(0, dp2 + 1, 4)
              .map!(i => bin2hex.get(bn2[i..min(i + 4, p)]
                                     .tr("0", " ")
                                     .stripLeft
                                     .tr(" ", "0"),
                                     bn2[i .. i + 1]))
              .join;
    immutable bn3 = bn2[dp2 + 1 .. p];
    immutable extra0b = "0".replicate(4 - bn3.length % 4);
    immutable bn4 = bn3 ~ extra0b;
    hx ~= iota(0, bn4.length, 4)
          .map!(i => bin2hex[bn4[i .. i + 4].tr("0", " ").stripLeft.tr(" ", "0")])
          .join;
    hx = (neg ? "-" : "") ~ "0x" ~ hx ~ bn2[p .. p+2] ~ bn2[p + 2 .. $].to!int(2).text;
    return hx.to!real;
}

void main() /*@safe*/ {
    immutable x = 23.34375;
    immutable y1 = x.dec2bin;
    y1.writeln;
    writefln("%.6f", y1.bin2dec);
    immutable y2 = dec2bin(-x);
    y2.writeln;
    y2.bin2dec.writeln;
    writefln("%.6f", "1011.11101p+0".bin2dec);
}
