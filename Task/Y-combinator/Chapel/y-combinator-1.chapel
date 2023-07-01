proc fixz(f) {
  record InnerFunc {
    const xi;
    proc this(a) { return xi(xi)(a); }
  }
  record XFunc {
    const fi;
    proc this(x) { return fi(new InnerFunc(x)); }
  }
  const g = new XFunc(f);
  return g(g);
}

record Facz {
  record FacFunc {
    const fi;
    proc this(n: int): int {
      return if n <= 1 then 1 else n * fi(n - 1); }
  }
  proc this(f) { return new FacFunc(f); }
}

record Fibz {
  record FibFunc {
    const fi;
    proc this(n: int): int {
      return if n <= 1 then n else fi(n - 2) + fi(n - 1); }
  }
  proc this(f) { return new FibFunc(f); }
}

const facz = fixz(new Facz());
const fibz = fixz(new Fibz());

writeln(facz(10));
writeln(fibz(10));
