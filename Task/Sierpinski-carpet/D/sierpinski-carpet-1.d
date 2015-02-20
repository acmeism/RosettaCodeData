import std.stdio, std.string, std.algorithm, std.array;

auto sierpinskiCarpet(in int n) pure nothrow @safe {
    auto r = ["#"];
    foreach (immutable _; 0 .. n) {
        const p = r.map!q{a ~ a ~ a}.array;
        r = p ~ r.map!q{a ~ a.replace("#", " ") ~ a}.array ~ p;
    }
    return r.join('\n');
}

void main() {
    3.sierpinskiCarpet.writeln;
}
