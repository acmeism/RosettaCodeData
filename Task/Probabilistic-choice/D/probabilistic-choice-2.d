void main() {
  import std.stdio, std.random, std.algorithm, std.range;

  enum int nTrials = 1_000_000;
  const items = "aleph beth gimel daleth he waw zayin heth".split;
  const pr = [1/5., 1/6., 1/7., 1/8., 1/9., 1/10., 1/11., 1759/27720.];

  double[pr.length] cumulatives = pr[];
  foreach (immutable i, ref c; cumulatives[1 .. $ - 1])
    c += cumulatives[i];
  cumulatives[$ - 1] = 1.0;

  double[pr.length] counts = 0.0;
  auto rnd = Xorshift(unpredictableSeed);
  foreach (immutable _; 0 .. nTrials)
    counts[cumulatives[].countUntil!(c => c >= rnd.uniform01)]++;

  writeln("Item    Target prob  Attained prob");
  foreach (name, p, co; zip(items, pr, counts[]))
    writefln("%-7s %.8f   %.8f", name, p, co / nTrials);
}
