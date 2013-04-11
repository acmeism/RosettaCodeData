def [F, M] := [
  fn n { if (n <=> 0) { 1 } else { n - M(F(n - 1)) } },
  fn n { if (n <=> 0) { 0 } else { n - F(M(n - 1)) } },
]
