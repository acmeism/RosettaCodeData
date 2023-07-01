import std.stdio, std.conv, std.array, std.regex, std.utf,
       std.algorithm;

string reEncode(string s) {
    validate(s); // Throw if it's not a well-formed UTF string
    static string rep(Captures!string m) {
        auto c = canFind("0123456789#", m[1]) ? "#" ~ m[1] : m[1];
        return text(m.hit.length / m[1].length) ~ c;
    }
    return std.regex.replace!rep(s, regex(`(.|[\n\r\f])\1*`, "g"));
}


string reDecode(string s) {
    validate(s); // Throw if it's not a well-formed UTF string
    static string rep(Captures!string m) {
        string c = m[2];
        if (c.length > 1 && c[0] == '#')
            c = c[1 .. $];
        return replicate(c, to!int(m[1]));
    }
    auto r=regex(`(\d+)(#[0123456789#]|[\n\r\f]|[^0123456789#\n\r\f]+)`
                 , "g");
    return std.regex.replace!rep(s, r);
}

void main() {
    auto s = "尋尋覓覓冷冷清清淒淒慘慘戚戚\nWWWWWWWWWWWWBWWWWWWWWWWW" ~
             "WBBBWWWWWWWWWWWWWWWWWWWWWWWWBWWWWWWWWWWWWWW\n" ~
             "11#222##333";
    assert(s == reDecode(reEncode(s)));
}
