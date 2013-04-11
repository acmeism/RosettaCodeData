import std.stdio, std.system;

void main() {
  writefln("word size = ", size_t.sizeof * 8);
  writefln(endian == Endian.LittleEndian ? "little" : "big", " endian");
}
