import std.stdio, std.algorithm;

int distance(in string s1, in string s2) pure nothrow {
  auto costs = new int[s2.length + 1];

  foreach (immutable i; 0 .. s1.length + 1) {
    int lastValue = i;
    foreach (immutable j; 0 .. s2.length + 1) {
      if (i == 0)
        costs[j] = j;
      else {
        if (j > 0) {
          int newValue = costs[j - 1];
          if (s1[i - 1] != s2[j - 1])
            newValue = min(newValue, lastValue, costs[j]) + 1;
          costs[j - 1] = lastValue;
          lastValue = newValue;
        }
      }
    }

    if (i > 0)
      costs[$ - 1] = lastValue;
  }

  return costs[$ - 1];
}

void main() {
  foreach (p; [["kitten", "sitting"], ["rosettacode", "raisethysword"]])
    writefln("distance(%s, %s): %d", p[0], p[1], distance(p[0], p[1]));
}
