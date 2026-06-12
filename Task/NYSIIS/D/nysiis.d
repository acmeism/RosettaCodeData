import std.stdio, std.regex, std.algorithm, std.range, std.string;

string replaceAt(in string text, in ulong pos, in string[] fromList,
                 in string[] toList) pure /*nothrow*/ @safe {
    foreach (const f, const t; zip(fromList, toList))
        if (text[pos .. $].startsWith(f))
            return [text[0 .. pos], t, text[pos + f.length .. $]].join;
    return text;
}

string replaceEnd(in string text, in string[] fromList,
                  in string[] toList) pure /*nothrow*/ @safe {
    foreach (const f, const t; zip(fromList, toList))
        if (text.endsWith(f))
            return text[0 .. $ - f.length] ~ t;
    return text;
}

string nysiis(string name) /*pure nothrow*/ @safe {
    enum vowels = "AEIOU";
    name = name.replaceAll(r"\W".regex, "").toUpper;
    name = name.replaceAt(0, ["MAC", "KN", "K", "PH", "PF", "SCH"],
                             ["MCC", "N",  "C", "FF", "FF", "SSS"]);
    name = name.replaceEnd(["EE", "IE", "DT", "RT", "RD", "NT", "ND"],
                           ["Y",  "Y",  "D",  "D",  "D",  "D",  "D"]);
    string key = name[0 .. 1];
    string key1;

    foreach (immutable i; 1 .. name.length) {
        immutable n_1 = name[i - 1 .. i];
        immutable n = name[i];
        immutable n1b = (i + 1 < name.length) ? name[i+1 .. i+2] : "";
        name = name.replaceAt(i, ["EV"] ~ vowels.split(""), ["AF"] ~
                              ["A"].replicate(5));
        name = name.replaceAt(i, "QZM".split(""), "GSN".split(""));
        name = name.replaceAt(i, ["KN", "K"], ["N", "C"]);
        name = name.replaceAt(i, ["SCH", "PH"], ["SSS", "FF"]);
        if (n == 'H' && (!vowels.canFind(n_1) || !vowels.canFind(n1b)))
            name = [name[0 .. i], n_1, name[i + 1 .. $]].join;
        if (n == 'W' && vowels.canFind(n_1))
            name = [name[0 .. i], "A", name[i + 1 .. $]].join;
        if (!key.empty && key[$ - 1] != name[i])
            key ~= name[i];
    }

    key = replaceEnd(key, ["S"], [""]);
    key = replaceEnd(key, ["AY"], ["Y"]);
    return key1 ~ replaceEnd(key, ["A"], [""]);
}

void main() @safe {
    immutable names = ["Bishop", "Carlson", "Carr", "Chapman",
        "Franklin", "Greene", "Harper", "Jacobs", "Larson", "Lawrence",
        "Lawson", "Louis, XVI", "Lynch", "Mackenzie", "Matthews",
         "McCormack", "McDaniel", "McDonald", "Mclaughlin", "Morrison",
         "O'Banion", "O'Brien", "Richards", "Silva", "Watkins",
         "Wheeler", "Willis", "brown, sr", "browne, III", "browne, IV",
         "knight", "mitchell", "o'daniel"];

    foreach (immutable name; names)
        writefln("%11s: %s", name, name.nysiis);
}
