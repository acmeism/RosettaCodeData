const masks = for i in 0 .. 7 do (1 << i): uint(8); // faster bit twiddling

proc countPrimes(lmt: uint(64)): int(64) {
  if lmt < 3 { if lmt < 2 { return 0; } else { return 1; } } // odds only!
  inline proc half(x: int): int { return (x - 1) >> 1; } // convenience function
  inline proc divide(nm: uint(64), d: uint(64)): int {
    return (nm: real(64) / d: real(64)): int; } // floating point div faster
  const sqrtn = sqrt(lmt: real(64)): uint(64);
  const mxndx = (sqrtn - 1): int / 2;
  const dom = {0 .. mxndx}; const csz = (mxndx + 8) / 8;
  var smalls = for i in dom do i: uint(32);
  var roughs = for i in dom do (i + i + 1): uint(32);
  var larges = for i in dom do ((lmt / (i + i + 1)) - 1) >> 1;
  var cullbuf: [0 ..< csz] uint(8);

  // partial sieve loop, adjusting larges/smalls, compressing larges/roughs...
  var nobps = 0; var rilmt = mxndx;
  for bp in 3: uint(64) .. by 2 {
    const i = (bp >> 1): int; const sqri = (i + i) * (i + 1);
    if sqri > mxndx { break; } // up to quad root of counting range
    if (cullbuf[i >> 3] & masks[i & 7]) != 0 { continue; } // loop not prime
    cullbuf[i >> 3] |= masks[i & 7]; // cull bp itself as not a rough
    for ci in sqri .. mxndx by bp { // do partial sieving pass for `bp`...
      cullbuf[ci >> 3] |= masks[ci & 7]; } // cull all multiples of `bp`

    // now adjust `larges` for latest partial sieve pass...
    var ori = 0; // compress input rough index to output one
    for iri in 0 .. rilmt {
      const r = roughs[iri]: uint(64); const rci = (r >> 1): int;
      if (cullbuf[rci >> 3] & masks[rci & 7]) != 0 {
        continue; } // skip culled roughs in last partial sieving pass
      const d = bp: uint(64) * r;
      larges[ori] = larges[iri] -
                      (if d <= sqrtn then
                         larges[smalls[(d >> 1): int] - nobps]
                       else smalls[half(divide(lmt, d))]: uint(64)) + nobps;
      roughs[ori] = r: uint(32); ori += 1;
    }

    var si = mxndx; // and adjust `smalls` for latest partial sieve pass...
    for bpm in bp .. (sqrtn / bp - 1) | 1 by -2 {
      const c = smalls[(bpm >> 1): int] - nobps: uint(32);
      const e = ((bpm * bp) >> 1): int;
      while si >= e { smalls[si] -= c; si -= 1; }
    }

    nobps += 1; rilmt = ori - 1;
  }

  var ans = larges[0]; // answer from larges, adjusting for over subtraction...
  for i in 1 .. rilmt { ans -= larges[i]; } // combine!
  ans += (rilmt + 1 + 2 * (nobps - 1)) * rilmt / 2; // adjust!

  // add final adjustment for pairs of current roughs to cube root of range...
  for ri in (1 ..) { // break when reaches cube root of counting range...
    const p = roughs[ri]: uint(64); const q = lmt / p;
    const ei = smalls[half(divide(q, p))]: int - nobps;
    if ei <= ri { break; } // break here when no more pairs!
    for ori in ri + 1 .. ei { // for all pairs never the same prime!
      ans += smalls[half(divide(q, roughs[ori]))]: int(64); }
    // adjust for over subtractions above...
    ans -= (ei - ri): uint(64) * (nobps: uint(64) + ri: uint(64) - 1);
  }

  return ans: int(64) + 1; // add one for only even prime of two!
}
