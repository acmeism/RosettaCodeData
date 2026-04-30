// this is the longer version...
/*
proc fixy(f) {
  record InnerFunc {
    const xi;
    proc this() { return xi(xi); }
  }
  record XFunc {
    const fi;
    proc this(x) { return fi(new InnerFunc(x)); }
  }
  const g = new XFunc(f);
  return g(g);
}
// */

// short version using direct recursion as Chapel has...
// note that this version of fix uses function recursion in its own definition;
// thus its use just means that the recursion has been "pulled" into the "fix" function,
// instead of the function that uses it...
proc fixy(f) {
  record InnerFunc { const fi; proc this() { return fixy(fi); } }
  return f(new InnerFunc(f));
}

record Facy {
  record FacFunc {
    const fi;
    proc this(n: int): int {
        return if n <= 1 then 1 else n * fi()(n - 1); }
  }
  proc this(f) { return new FacFunc(f); }
}

record Fiby {
  record FibFunc {
    const fi;
    proc this(n: int): int {
      return if n <= 1 then n else fi()(n - 2) + fi()(n - 1); }
  }
  proc this(f) { return new FibFunc(f); }
}

const facy = fixy(new Facy());
const fibz = fixy(new Fiby());

writeln(facy(10));
writeln(fibz(10));
