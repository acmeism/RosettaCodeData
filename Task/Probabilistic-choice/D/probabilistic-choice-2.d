import std.stdio, std.random, std.algorithm, std.range;

void main() {
  enum int nTrials = 1_000_000;
  auto items = "aleph beth gimel daleth he waw zayin heth".split();
  enum pr = [1/5., 1/6., 1/7., 1/8., 1/9., 1/10., 1/11., 1759/27720.];

  double[pr.length] cumulatives = pr[];
  foreach (i, ref c; cumulatives[1 .. $ - 1])
    c += cumulatives[i];
  cumulatives[$ - 1] = 1.0;

  double[pr.length] counts = 0.0;
  auto rnd = Xorshift(unpredictableSeed());
  foreach (_; 0 .. nTrials) {
    double rnd01 = rnd.front / cast(double)rnd.max;
    rnd.popFront();
    counts[cumulatives[].countUntil!(c => c >= rnd01)()]++;
  }

  writeln("Item    Target prob  Attained prob");
  foreach (name, p, co; zip(items, pr, counts[]))
    writefln("%-7s %.8f   %.8f", name, p, co / nTrials);
}
