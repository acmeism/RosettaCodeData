void main() {
    import std.stdio, std.base64, std.net.curl, std.string;

    const f = "http://rosettacode.org/favicon.ico".get.representation;
    Base64.encode(f).writeln;
}
