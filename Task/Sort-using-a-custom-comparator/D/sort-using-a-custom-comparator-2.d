void main() {
    import std.stdio, std.string, std.algorithm;

    auto parts = "here are Some sample strings to be sorted".split;

    parts.multiSort!("a.length > b.length", "a.toUpper < b.toUpper");

    parts.writeln;
}
