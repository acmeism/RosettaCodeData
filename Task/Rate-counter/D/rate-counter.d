import std.stdio;
import std.conv;
import std.datetime.stopwatch;

int a;
void f0() {}
void f1() { auto b = a; }
void f2() { auto b = to!string(a); }

	
void main()
{
  auto r = benchmark!(f0, f1, f2)(10_000);

  writeln("Time fx took to run 10,000 times:\n");
  writeln("f0: ", r[0]);
  writeln("f1: ", r[1]);
  writeln("f2: ", r[2]);
	
}
