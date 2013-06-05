import std.stdio, std.string, std.algorithm, std.array;

auto sierpinskiCarpet(in int n) /*pure nothrow*/ {
    auto r = ["#"];
    foreach (_; 0 .. n) {
        auto p = r.map!q{a ~ a ~ a}.array;
        r = p ~ r.map!q{a ~ a.replace("#", " ") ~ a}.array ~ p;
    }
    return r.join("\n");
}

void main() {
    3.sierpinskiCarpet.writeln;
}
