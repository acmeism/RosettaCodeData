sub agm {
  ($^z, {(.re+.im)/2 + (.re*.im).sqrt*1i} ... * ≅ *)
  .tail.re
}

say agm 1 + 1i/2.sqrt
