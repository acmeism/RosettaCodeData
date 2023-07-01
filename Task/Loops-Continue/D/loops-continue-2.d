import std.stdio;

void main()
{
  foreach(i; 1..11) i % 5 ? writef("%s, ", i) : writeln(i);
}
