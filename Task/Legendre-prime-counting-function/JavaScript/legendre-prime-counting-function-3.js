const masks = new Uint8Array(8); // faster than bit twiddling!
for (let i = 0; i < 8; ++i) masks[i] = (1 << i) >>> 0;

function countPrimesTo(lmt) {
  if (lmt < 3) { if (lmt < 2) return 0; else return 1; }
  function half(x) { return (x - 1) >>> 1; }
  function divide(nm, d) { return (nm / d) >>> 0; }
  const sqrtlmt = Math.trunc(Math.sqrt(lmt));
  const mxndx = (sqrtlmt - 1) >>> 1; const cbsz = (mxndx + 8) >>> 3;
  const cullbuf = new Uint8Array(cbsz);
  const smalls = new Uint32Array(mxndx + 1);
  for (let i = 0; i <= mxndx; ++i) smalls[i] = i >>> 0;
  const roughs = new Uint32Array(mxndx + 1);
  for (let i = 0; i <= mxndx; ++i) roughs[i] = (i + i + 1) >>> 0;
  const larges = new Float64Array(mxndx + 1);
  for (let i = 0; i <= mxndx; ++i) larges[i] =
    Math.trunc((Math.trunc(lmt / (i + i + 1)) - 1) / 2);

  // partial sieve loop, adjusting larges/smalls, compressing larges/roughs...
  let nobps = 0 >>> 0; let rilmt = mxndx; let bp = 3 >>> 0;
  while (true) { // break when square root is reached
    const i = bp >>> 1; let sqri = ((i + i) * (i + 1)) >>> 0;
    if (sqri > mxndx) break; // partial sieving pass if bp is prime:
    if ((cullbuf[i >> 3] & masks[i & 7]) == 0) {
      cullbuf[i >> 3] |= masks[i & 7]; // cull bp!
      for (; sqri <= mxndx; sqri += bp)
        cullbuf[sqri >> 3] |= masks[sqri & 7]; // cull bp mults!

      // now adjust `larges` for latest partial sieve pass...
      var ori = 0 // compress input rough index to output one
      for (let iri = 0; iri <= rilmt; ++iri) {
        const r = roughs[iri]; const rci = r >>> 1; // skip roughs just culled!
        if ((cullbuf[rci >> 3] & masks[rci & 7]) != 0) continue;
        const d = bp * r;
        larges[ori] = larges[iri] -
                        ( (d <= sqrtlmt) ? larges[smalls[d >>> 1] - nobps]
                            : smalls[half(divide(lmt, d))] ) +
                          nobps; // base primes count over subtracted!
        roughs[ori++] = r;
      }

      let si = mxndx // and adjust `smalls` for latest partial sieve pass...
      for (let bpm = (sqrtlmt / bp - 1) | 1; bpm >= bp; bpm -= 2) {
        const c = smalls[bpm >>> 1] - nobps;
        const ei = ((bpm * bp) >>> 1);
        while (si >= ei) smalls[si--] -= c;
      }

      nobps++; rilmt = ori - 1;
    }
    bp += 2;
  }

  // combine results to here; correcting for over subtraction in combining...
  let ans = larges[0]; for (let i = 1; i <= rilmt; ++i) ans -= larges[i];
  ans += Math.trunc((rilmt + 1 + 2 * (nobps - 1)) * rilmt / 2);

  // add final adjustment for pairs of current roughs to cube root of range...
  let ri = 0
  while (true) { // break when reaches cube root of counting range...
    const p = roughs[++ri]; const q = Math.trunc(lmt / p);
    const ei = smalls[half(divide(q, p))] - nobps;
    if (ei <= ri) break; // break here when no more pairs!
    for (let ori = ri + 1; ori <= ei; ++ori)
      ans += smalls[half(divide(q, roughs[ori]))];
    ans -= (ei - ri) * (nobps + ri - 1);
  }

  return ans + 1; // add one for only even prime of two!
}
