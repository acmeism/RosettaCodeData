import std.stdio, std.string, std.net.curl, std.algorithm;

void main() {
    foreach (line; "http://tycho.usno.navy.mil/cgi-bin/timer.pl".byLine)
        if (line.length > 4 && line.indexOf(" UTC") != -1)
            line[4 .. $].writeln;
}
