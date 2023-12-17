import std.stdio;
import std.net.curl;
auto data = get("https://sourceforge.net");
writeln(data);
