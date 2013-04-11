import std.stdio, std.range;

void main() {
  auto D = [90.5, 47, 58, 29, 22, 32, 55, 5, 55, 73.5];
  auto R = recurrence!q{(a[n-1].dup[] -= a[n-1][1..$])[0..$-1]}(D);
  foreach (di; take(R, D.length))
    writeln(di);
}
