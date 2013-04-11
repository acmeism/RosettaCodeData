import std.stdio, std.string, std.algorithm, std.typecons;

void main() {
  auto data = "here are Some sample strings to be sorted".split();
  data.schwartzSort!(s => tuple(-s.length, s.toUpper()))();
  writeln(data);
}
