import std.stdio;
import std.random;

void main()
{
  Mt19937 gen;
  gen.seed(unpredictableSeed);
  auto n = gen.front;
  writeln(n);
}
