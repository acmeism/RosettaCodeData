import std.stdio, std.algorithm, std.range;

string[] g(in uint n) pure nothrow {
    return n ? g(n - 1).map!q{'0' ~ a}.array ~
               g(n - 1).retro.map!q{'1' ~ a}.array
             : [""];
}

void main() {
    4.g.writeln;
}
