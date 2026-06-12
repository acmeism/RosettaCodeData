import std.algorithm.searching;
import std.stdio;
import std.string;

string textBetween(string source, string beg, string end) in {
    assert(beg.length != 0, "beg cannot be empty");
    assert(end.length != 0, "end cannot be empty");
} body {
    ptrdiff_t si = source.indexOf(beg);
    if (beg == "start") {
        si = 0;
    } else if (si < 0) {
        return "";
    } else {
        si += beg.length;
    }

    auto ei = source.indexOf(end, si);
    if (ei < 0 || end == "end") {
        return source[si..$];
    }

    return source[si..ei];
}

void print(string s, string b, string e) {
    writeln("text: '", s, "'");
    writeln("start: '", b, "'");
    writeln("end: '", e, "'");
    writeln("result: '", s.textBetween(b, e), "'");
    writeln;
}

void main() {
    print("Hello Rosetta Code world", "Hello ", " world");
    print("Hello Rosetta Code world", "start", " world");
    print("Hello Rosetta Code world", "Hello ", "end");
    print("</div><div style=\"chinese\">你好嗎</div>", "<div style=\"chinese\">", "</div>");
    print("<text>Hello <span>Rosetta Code</span> world</text><table style=\"myTable\">", "<text>", "<table>");
    print("<table style=\"myTable\"><tr><td>hello world</td></tr></table>", "<table>", "</table>");
    print("The quick brown fox jumps over the lazy other fox", "quick ", " fox");
    print("One fish two fish red fish blue fish", "fish ", " red");
    print("FooBarBazFooBuxQuux", "Foo", "Foo");
}
