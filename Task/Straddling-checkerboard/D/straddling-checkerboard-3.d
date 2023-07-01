import std.stdio, std.string, std.algorithm, std.regex, std.array, std.range, std.typecons;

immutable string[const string] val2key, key2val;

static this() pure /*nothrow @safe*/ {
    immutable aa = ["A":"30", "B":"31", "C":"32", "D":"33", "E":"5", "F":"34", "G":"35",
        "H":"0", "I":"36", "J":"37", "K":"38", "L":"2", "M":"4", ".":"78", "N":"39",
        "/":"79", "O":"1", "0":"790", "P":"70", "1":"791", "Q":"71", "2":"792",
        "R":"8", "3":"793", "S":"6", "4":"794", "T":"9", "5":"795", "U":"72",
        "6":"796", "V":"73", "7":"797", "W":"74", "8":"798", "X":"75", "9":"799",
        "Y":"76", "Z":"77"];
    val2key = aa;
    key2val = aa.byKeyValue.map!(t => tuple(t.value, t.key)).assocArray;
}

string encode(in string s) pure /*nothrow*/ @safe {
    return s.toUpper.split("").map!(c => val2key.get(c, "")).join;
}

string decode(in string s) /*pure nothrow*/ @safe {
    return s.matchAll("79.|3.|7.|.").map!(g => key2val.get(g[0], "")).join;
}

void main() @safe {
    immutable s = "One night-it was on the twentieth of March, 1888-I was returning";
    s.encode.writeln;
    s.encode.decode.writeln;
}
