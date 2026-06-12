import std.algorithm;
import std.file;
import std.stdio;
import std.string;

void main() {
    "unixdict.txt".readText().splitLines().each!((s) {
        if (s.canFind("a") && s.canFind("b") && s.canFind("c")
        && (s.countUntil("a") < s.countUntil("b")) && (s.countUntil("b") < s.countUntil("c"))) {
            writeln(s);
        }
    });
}
