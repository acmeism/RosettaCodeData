import std.stdio, std.algorithm, std.range;

auto pascal(in int n) /*pure nothrow*/ {
   auto p = [[1]];
   foreach (_; 1 .. n)
      p ~= zip(p[$-1] ~ 0, 0 ~ p[$-1]).map!q{a[0] + a[1]}().array();
   return p;
}

void main() {
    writeln(pascal(5));
}
