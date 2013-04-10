import std.stdio, std.random, std.algorithm, std.range;

enum target = "METHINKS IT IS LIKE A WEASEL"d;
enum C = 100;  // Number of children in each generation.
enum P = 0.05; // Mutation probability.
auto alphabet = " ABCDEFGHIJLKLMNOPQRSTUVWXYZ"d.dup;
const fitness = (dchar[] s) => count!"a[0] != a[1]"(zip(s, target));
const rndc = () => alphabet[uniform(0, $)];
const mutate = (dchar[] s) =>
               s.map!(a => uniform(0., 1.) < P ? rndc() : a)().array();

void main() {
  auto parent = target.length.iota().map!(_ => rndc())().array();
  for (int gen = 1; parent != target; gen++) {
    auto offs = parent.repeat(C).map!mutate().array();
    parent = offs.minPos!((a, b) => fitness(a) < fitness(b))()[0];
    writefln("Gen %2d, dist=%2d: %s", gen, fitness(parent), parent);
  }
}
