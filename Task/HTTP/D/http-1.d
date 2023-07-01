void main() {
  import std.stdio, std.net.curl;
  writeln(get("http://google.com"));
}
