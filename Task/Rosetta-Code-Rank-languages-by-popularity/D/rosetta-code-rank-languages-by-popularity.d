import std.stdio, std.algorithm, std.conv, std.array, std.regex,
       std.typecons, std.net.curl;

void main() {
    // Get a list of just the programming languages.
    immutable r1 = `"title":"Category:([^"]+)"`;
    const languages = get("www.rosettacode.org/w/api.php?action=query"~
                          "&list=categorymembers&cmtitle=Category:Pro"~
                          "gramming_Languages&cmlimit=500&format=json")
                      .match(r1.regex("g")).map!q{a[1].dup}.array;

    // Get a pagecount for all categories.
    immutable r2 = `title="Category:([^"]+)">[^<]+` ~
                   `</a>[^(]+\((\d+) members\)`;
    const pairs = get("www.rosettacode.org/w/index.php?" ~
                      "title=Special:Categories&limit=5000")
                  .match(r2.regex("g"))
                  .filter!(m => languages.canFind(m[1]))
                  .map!(m => tuple(m[2].to!uint, m[1].dup))
                  .array.sort!q{a > b}.release;

    foreach (i, res; pairs)
        writefln("%3d. %3d - %s", i + 1, res[]);
}
