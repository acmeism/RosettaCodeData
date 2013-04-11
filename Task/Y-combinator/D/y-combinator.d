import std.stdio, std.traits, std.algorithm, std.range;

auto Y(F)(F f) {
  alias D = void delegate();
  alias Ret = ReturnType!(ParameterTypeTuple!F);
  alias Args = ParameterTypeTuple!(ParameterTypeTuple!F);

  return ((Ret delegate(Args) delegate(D) x) =>
    x(cast(D)x))(
      (D y) =>
        f((Args args) =>
          (cast(Ret delegate(Args))(cast(D delegate(D))y)(y))(args)
        )
    );
}

void main() { // Demo code --------------------
  auto factorial = Y((int delegate(int) self) =>
    (int n) => 0 == n ? 1 : n * self(n - 1)
  );

  auto ackermann = Y((ulong delegate(ulong, ulong) self) =>
    (ulong m, ulong n) {
      if (m == 0) return n + 1;
      if (n == 0) return self(m - 1, 1);
      return self(m - 1, self(m, n - 1));
    });

  writeln("factorial: ", map!factorial(iota(10)));
  writeln("ackermann(3, 5): ", ackermann(3, 5));
}
